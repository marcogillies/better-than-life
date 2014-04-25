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
	upgradeStatus = models.BooleanField()
	colour = models.TextField()
	mouseX = models.FloatField()
	mouseY = models.FloatField()

	#log = models.TextField()
	
	# Override the __unicode__() method to return out something meaningful!
	def __unicode__(self):
		return self.user.username
	
	class Meta:
		permissions = (
			("view_secret", "Can see secret things"),
			("select_stream", "Can select different streams"),
			("chat", "Can contribute to the chats"),
		)

class LogItem(models.Model):
	user = models.ForeignKey(User)

	category = models.TextField()
	content = models.TextField()

	def __unicode__(self):
		return self.category + ":" + self.content

