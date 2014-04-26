from django.db import models
from django.contrib.auth.models import User

SECTIONS = (
		("advance", "advance"),
		("preshow", "preshow"),
		("arrival", "arrival"),
		("QandA", "QandA"),
		("ouija", "ouija"),
	)

# Create your models here.

class Show(models.Model):


	name = models.CharField(max_length=20)
	date = models.DateTimeField('date and time')
	act  = models.IntegerField(name="act", default=-1)
	section = models.CharField(max_length=20,
                              choices=SECTIONS,
                              default="advance")

	def __unicode__(self):  # Python 3: def __str__(self):
		return self.name


class UserProfile(models.Model):
	# This line is required. Links UserProfile to a User model instance.
	user = models.OneToOneField(User)

	show = models.ForeignKey(Show)

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
			("secret", "Can see secret places"),
			("select_stream", "Can select different streams"),
			("chat", "Can contribute to the chats"),
			("group_red", "Part of the red group"),
			("group_green", "Part of the green group"),
			("group_blue", "Part of the blue group"),
		)

class LogItem(models.Model):
	user = models.ForeignKey(User)
	show = models.ForeignKey(Show)

	date = models.DateTimeField(auto_now_add=True, blank=True)

	act = models.IntegerField(name="act")
	section = models.CharField(max_length=20,
                              choices=SECTIONS)

	category = models.TextField()
	content = models.TextField()

	def __unicode__(self):
		return self.category + ":" + self.content

