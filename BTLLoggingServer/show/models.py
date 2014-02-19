from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class Show(models.Model):
	name = models.CharField(max_length=200)
	date = models.DateTimeField('date and time')

	def __unicode__(self):  # Python 3: def __str__(self):
		return self.name

class UserProfile(models.Model):
	# This line is required. Links UserProfile to a User model instance.
	user = models.OneToOneField(User)

	# The additional attributes we wish to include.
	credit = models.IntegerField()
	colour = models.TextField()
	
	# Override the __unicode__() method to return out something meaningful!
	def __unicode__(self):
		return self.user.username

