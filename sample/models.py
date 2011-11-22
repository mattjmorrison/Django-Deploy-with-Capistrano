from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=25)
    alias = models.CharField(max_length=50)
    last_name = models.CharField(max_length=100)
    something = models.IntegerField()
