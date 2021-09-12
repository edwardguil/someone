import openai
openai.api_key = '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'

def someone(prompt,userName,aiName):
    """"function which takes message from user, and returns response

    params:
        message: str
        chat: int
        user: int

    returns AI Response
    """
    ans = openai.Completion.create(
      engine = "davinci",
      prompt=prompt,
      temperature=0.9,
      max_tokens=64,
      top_p=0,
      frequency_penalty=0.1,
      presence_penalty=0.6,
      stop=["\n", " "+userName+":", " "+aiName+":"]
    )
    for a in ans["choices"]:
        answer=(a["text"])

    return answer



