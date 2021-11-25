from django.db import models
from django.db.models.deletion import CASCADE, SET_NULL
from users.models import TempUser as User

# Create your models here.

class Chat(models.Model):
    admin = models.ForeignKey(User,null=True,on_delete=models.SET_NULL)
    ai = models.ForeignKey(User,related_name='chats',null=True, on_delete=models.SET_NULL)
    #created = models.DateTimeField(auto_now_add=True)

class Message(models.Model):
    user = models.ForeignKey(User, null=True,on_delete=models.SET_NULL)
    chat = models.ForeignKey(Chat, on_delete=models.CASCADE, related_name='messages')
    #created = models.DateTimeField(auto_now_add=True)
    text = models.TextField(max_length=12800)