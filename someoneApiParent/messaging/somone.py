import openai
import requests
import os

def someone(prompt,aiName,userName):
    """"function which takes message from user, and returns response
    
    params:
        message: str
        chat: int
        user: int

    returns AI Response
    """

    header1 = {
        "Authorization": "Bearer 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"
    }

    params = {
        "prompt": prompt,
        "max_tokens": 5,
        "temperature": 1,
        "top_p": 1,
        "n": 1,
        "stream": False,
        "logprobs": '',
        "stop": "\n"
    }
    davinciUrl = "https://api.openai.com/v1/engines/davinci/completions"
    resp = requests.post(url=davinciUrl,params=params,headers=header1)

    return resp

someone("Blake: Hello AI, how are you? \n","AI","Blake")



