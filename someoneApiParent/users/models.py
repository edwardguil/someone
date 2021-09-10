from django.db import models

class TempUser(models.Model):
    ##Generate a JWT and Return it.
    firstName = models.CharField(max_length=200)