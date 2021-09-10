from django.db import models
from django.db.models.fields import CharField, EmailField
from django.db.models.fields.related import ForeignKey

# Create your models here.

class User(models.Model):
    firstName = CharField(max_length=60)
    lastName = CharField(max_length=60)
    email = EmailField()