from django.db import models
from user import User

# Create your models here.

class Chat(models.Model):
    admin = models.ForeignKey(User)
    participants = models.ManyToManyField(User,related_name='chats')
    created = models.DateTimeField(auto_now_add=True)

class Message(models.Model):
    chat = models.ForeignKey(Chat, on_delete=models.CASCADE, related_name='messages')
    created = models.DateTimeField(auto_now_add=True)
    text = models.TextField(max_length=12800)