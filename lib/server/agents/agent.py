from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.prompts import ChatPromptTemplate, PromptTemplate, SystemMessagePromptTemplate, HumanMessagePromptTemplate
from typing import List, Dict, Any
from typing_extensions import TypedDict
from langchain_core.output_parsers import StrOutputParser, JsonOutputParser
from langgraph.graph import StateGraph, START, END
import os
from dotenv import load_dotenv
# from langchain.document_loaders import PyMuPDFLoader
from typing import List, Dict, Any, Optional
import pymupdf as fitz
from pydantic import BaseModel, Field
import re
load_dotenv()
os.environ["LANGMSTIH_TRACING"] = "true"
os.environ["LANGSMITH_PROJECT"] = f"Deployed MineD 2025"
llm = ChatGoogleGenerativeAI(
    model="gemini-1.5-flash",
    temperature=0,
    max_tokens=None,
    timeout=None,
    max_retries=2,
    # other params...
)

# Define Pydantic Model for PPT slides
class SlideContent(BaseModel):
    title: str = Field(..., description="Title of the particular slide")
    bullet_points: Optional[List[str]] = Field(None, description="Content in bullet points form for the slide")
    notes: Optional[str] = Field(None, description="Additional notes for the slide")
    images: Optional[List[str]] = Field(None, description="List of relevant image paths for the slide")

class PPTPresentation(BaseModel):
    title: str = Field(..., description="Title of the presentation")
    authors: List[str] = Field(..., description="List of authors of the presentation")
    institution: str = Field(..., description="Institution associated with the presentation")
    slides: List[SlideContent] = Field(..., description="List of slides, in the presentation,which are SlideContent schemas.")

class Dialogue(BaseModel):
    text: str = Field(..., description="The text of dialogue")

class Conversation(BaseModel):
    katherine: List[Dialogue] = Field(..., description="Katherine's dialogues")
    clay: List[Dialogue] = Field(..., description="Clay's dialogues")
    order: List[str] = Field(..., description="The order of dialogues denoted by the names of the speaker")

class ResPaperExtractState(TypedDict):
    pdf_path: Optional[str] = None  # Path to the PDF file
    extracted_text: Optional[str] = None  # Full extracted text from the PDF
    extracted_images: Optional[Dict[str,str]] = None  # Paths to extracted images
    slides_content: Optional[List[Dict[str, str]]] = None  # Prepared content for PowerPoint slides
    ppt_object: PPTPresentation
    summary_text: Optional[str] = None
    convo: Conversation = None

def clean_markdown_output(llm_out: str) -> str:
    # Remove leading and trailing triple backticks if present
    if not isinstance(llm_out, str):
        llm_out = str(llm_out.content)  # Extract string content from AIMessage
    return re.sub(r"^```(?:json)?\n?|```$", "", llm_out.strip())

def load_pdf(state: ResPaperExtractState):
    pdf_path = state["pdf_path"]
    doc = fitz.open(pdf_path)  # Load the PDF only once
    
    extracted_text = []
    extracted_images = dict()
    output_folder = "extracted_images"
    os.makedirs(output_folder, exist_ok=True)

    # Iterate through each page
    img_cntr=1
    for page_number, page in enumerate(doc):
        # Extract text
        text = page.get_text("text")
        extracted_text.append(text)

        # Extract images
        for img_index, img in enumerate(page.get_images(full=True)):
            xref = img[0]
            base_image = doc.extract_image(xref)
            image_bytes = base_image["image"]
            image_ext = base_image["ext"]
            img_filename = f"{output_folder}/page_{page_number+1}_img_{img_index+1}.{image_ext}"
            
            with open(img_filename, "wb") as img_file:
                img_file.write(image_bytes)
            
            extracted_images[f"Fig{img_cntr}"] = img_filename
            img_cntr+=1

    # Combine text from all pages
    full_text = "\n".join(extracted_text)

    # Update state
    return {"extracted_text": full_text, "extracted_images": extracted_images}

def generate_summary(state: ResPaperExtractState):
    extracted_text = state["extracted_text"]

    summary_template_string_2 = """
        You are an expert science communicator who specializes in breaking down complex research papers into engaging, conversational summaries. Your goal is to generate a summary that will be used to generate text for conversational podcast.
        The summary should be structured in a way that makes it engaging for a podcast discussion. 
        Include thought-provoking questions and key discussion points that make the findings compelling to a general audience.

        ### **Instructions:**
        - Start with an **intriguing hook** that captures the essence of the paper in an engaging way. 
        - Clearly state the **research problem** and why it matters.
        - Summarize the **key findings** and their implications, but in a way that sparks curiosity.
        - **Use an engaging tone** that makes it feel like a conversation rather than a dry summary.
        - Include at least **three discussion-worthy questions** that podcast hosts could debate.
        - Highlight any **visual elements** that could be useful for a graphical abstract, such as relationships between variables, experimental results, or unexpected insights.

        ### **Important Guidelines:**
        - Keep it insightful yet engaging—avoid overly technical jargon unless necessary.  
        - Don’t make the summary too short; ensure all important elements of the research are covered.  
        - Aim for a summary length of **300-500 words** to balance depth with readability.  
        - If applicable, include **real-world analogies** or examples to make the findings more relatable. 
        - Remember, the goal is to make the research accessible and interesting to a broad audience.
        - Return a single string with the summary text, acheiving the above objectives. 
        Now, using these guidelines, generate a well-structured summary of the following research paper: {text}  

    """
    summary_prompt = PromptTemplate.from_template(summary_template_string_2)
    # Generate summary with LLM
    summary_text = llm.invoke(summary_prompt.format(text=extracted_text))  # No chunking, single LLM call
    
    return {"summary_text": summary_text}

def generate_conversation(state: ResPaperExtractState):
    system_message_podcast = SystemMessagePromptTemplate.from_template(
    """You are an expert in creating/writing scripts for podcasts. 
    Consider the given scenario: Two people one girl and one boy who are in final year of their B.Tech, are discussing the given research paper to create an podcast of this research paper
    
    Boy's Name: Clay
    Girl's Name: Katherine
    
    The Girl has complete knowledge about this paper, while the boy doesn't know anything about the paper.
    
    Write a script for a podcast, wherein firstly the girl introduces the paper, but the boy seems clueless.So the boy ask the girl many questions about the paper, to understand the paper and learn more about the keyowrds and topics involved.
    
    The boy's question should cover all the possible doubt that one can have regarding the paper, and the girl should answer that questions correctly.

    General Guideline:
    - Intro must include the name, application and the authors (and their institution)
    - Consider the audience to be technically sound, so you can ue jargons
    - The boys questions should cover all the aspects from methodology, results, literature review, etc
    - Dont make it too obvious that they are discussing about the paper
    - Make the order such that the question asked by clay in previous dialogue is answered by katherine in this dialogue.

    Additional Guidelines:
    - Consider that the girl always starts first
    - Also give the order of dialogues, that are to be taken in a sequence
    - Make sure that the number of dialogues in the order and in the lists add up.
    - Both of them dont have to speak alternatively, they can heave continuous dialogues
    - Each and every question asked by clay has to be answered by katherine
    - Make sure that the both the persons are not inventing anything of their own, nor should they give any wrong information.
    - Don't give a name to this podcast
    - If a particular entity or its name can't be inferred, don't mention them as placeholders in the conversation
    -  Do not format the output in markdown, do not use triple backticks (` ``` `) or JSON code blocks.
    Ensure that the response is a valid JSON object that follows the expected schema.

        {format_instructions}
    """
    )

# Human Message: Supplies extracted text from the research paper
    human_message_podcast = HumanMessagePromptTemplate.from_template("Here is the summary of research paper:\n\n{summary_text}. \nMake sure the tone is {tone}")

    parser = JsonOutputParser(pydantic_object=Conversation)
    # Combine into a structured chat prompt
    chat_prompt_podcast = ChatPromptTemplate(
        messages=[system_message_podcast, human_message_podcast],
        partial_variables={"format_instructions": parser.get_format_instructions()}
    )
    summary_text = state["summary_text"]
    prompt = chat_prompt_podcast.invoke({"summary_text": summary_text, "tone": "informative"})
    # llm_out = llm.invoke(prompt)
    # parsed = parser_podcast.invoke(llm_out)
    llm_out = llm.invoke(prompt)
    cleaned_llm_out = clean_markdown_output(llm_out)
    parsed = parser.invoke(cleaned_llm_out)
    
    return {"convo":parsed}


def get_data(state):
    extracted_text = state["extracted_text"]
    system_message = SystemMessagePromptTemplate.from_template(
    """You are an expert in creating PowerPoint presentations. Generate a structured PowerPoint (PPT) presentation 
    that summarizes a research paper based on the provided extracted text. Follow these instructions:
    
    Remember that the objective of this PPT is for a third party to understand the key points of the research paper, and 
    give them a gist of the research paper.

    - Title Slide: Include the research paper title, authors, and institution.
    - Introduction Slide: Summarize the problem, objectives, and motivation.
    - Methods Slide: Briefly explain the methodology, datasets, and experimental setup.
    - Results Slide: Summarize key findings with bullet points. Mention any visuals (graphs, tables) found from the extracted text. You should definetly mention in the presentation any figures related to a performance metric or tables that are mentioned in the extracted text.
    - Discussion Slide: Explain the significance of results and compare with prior work.
    - Conclusion Slide: Summarize key takeaways and potential future work.
    - References Slide: Include citations if available.

    Additional Guidelines:
    - Keep slides concise (use bullet points).
    - Maintain a professional and visually appealing slide design.
    - Give the text in markdown format.
    - Each slide should have rich information content, summarizing the information related to the particular slide heading.
    - Also keep in mind that the text for each slide should not be too lengthy, and should be concise and to the point.
    - Do not format the output in markdown, do not use triple backticks (` ``` `) or JSON code blocks.
    Ensure that the response is a valid JSON object that follows the expected schema.

    {format_instructions}
    """
    )

    # Human Message: Supplies extracted text from the research paper
    human_message = HumanMessagePromptTemplate.from_template("Here is the extracted text:\n\n{extracted_text}")

    parser = JsonOutputParser(pydantic_object=PPTPresentation)
    # Combine into a structured chat prompt
    chat_prompt = ChatPromptTemplate(
        messages=[system_message, human_message],
        partial_variables={"format_instructions": parser.get_format_instructions()}
    )
    prompt = chat_prompt.invoke({"extracted_text": extracted_text})
    # Invoke LLM with structured output
    llm_out = llm.invoke(prompt)
    cleaned_llm_out = clean_markdown_output(llm_out)
    parsed = parser.invoke(cleaned_llm_out)
    
    return {"ppt_object": parsed}

builder = StateGraph(ResPaperExtractState)

builder.add_node("pdf-2-text", load_pdf)
builder.add_node("ppt-extract", get_data)
builder.add_node("summary-text", generate_summary)
builder.add_node("conversation", generate_conversation)

builder.add_edge(START, "pdf-2-text")
builder.add_edge("pdf-2-text", "ppt-extract")
builder.add_edge("pdf-2-text", "summary-text")
builder.add_edge("summary-text", "conversation")
builder.add_edge("ppt-extract", END)
builder.add_edge("conversation", END)
graph = builder.compile()
