from django.db import models
from django.db.models.deletion import SET_NULL

class TempUser(models.Model):
    ##Generate a JWT and Return it.
    firstName = models.CharField(max_length=200)