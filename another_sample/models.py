from django.db import models

class SampleOne(models.Model):
    first_column = models.IntegerField()
    second_column = models.IntegerField()
    third_column = models.IntegerField()
