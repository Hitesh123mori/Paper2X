import edge_tts
import asyncio

text = """
I’ve been exploring various research topics lately, particularly in the fields of deep learning and NLP. For my image classification project, I’ve been working with a pre-trained ResNet18 model on the CIFAR-10 dataset, which has shown significant performance improvements as mentioned in several papers. I’m also diving into U-Net for image segmentation tasks, especially for medical imaging applications like tumor detection, which uses its encoder-decoder structure with skip connections. On the NLP side, I'm deploying a BERT-based model for sentiment analysis of IMDb reviews on Google Cloud Platform. It's a bit tricky integrating everything with Flask, but I've seen papers that use services like Vertex AI to scale models efficiently, and I'm considering looking into that for future deployments.
"""
male_voice = "en-US-AndrewNeural"
female_voice = "en-US-EmmaMultilingualNeural"
text_to_tts = "Hello World"


async def amain(text: str):
    communicate = edge_tts.Communicate(text, female_voice)
    await communicate.save("text.mp3")
    print("Done")


asyncio.run(amain(text=text))
print("Finished")
