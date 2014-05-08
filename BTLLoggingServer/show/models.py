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

FEATURE_STATUSES = (
		("locked", "locked"),
		("unlocked", "unlocked"),
		("buyable", "buyable"),
	)

class Phase(models.Model):

	name = models.CharField(max_length=20)
	description = models.CharField(max_length=200)

	message = models.CharField(max_length=400)

	active = models.BooleanField(default=False)

	camera_status = models.CharField(max_length=20,
                              choices=FEATURE_STATUSES,
                              default="locked")
	chat_status = models.CharField(max_length=20,
                              choices=FEATURE_STATUSES,
                              default="locked")
	mouse_move_status = models.CharField(max_length=20,
                              choices=FEATURE_STATUSES,
                              default="locked")
	question_lottery_status = models.CharField(max_length=20,
                              choices=FEATURE_STATUSES,
                              default="locked")
	tommy_cam_status = models.CharField(max_length=20,
                              choices=FEATURE_STATUSES,
                              default="locked")
	reset_permissions = models.BooleanField(default=False)
	reset_credit = models.IntegerField(null=True, blank = True)

	next_phase = models.ForeignKey('self',null=True, blank = True)

	def __unicode__(self):
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

	date = models.DateTimeField('date and time',auto_now_add=True)	

	act = models.IntegerField(name="act")
	section = models.CharField(max_length=20,
                              choices=SECTIONS)

	category = models.TextField()
	content = models.TextField()

	def __unicode__(self):
		return self.category + ":" + self.content

class Stream(models.Model):
	name = models.CharField(max_length = 30)
	SEID = models.IntegerField()
	type = models.CharField(max_length=20, choices=(("video", "video"), ("chat", "chat")))

	def __unicode__(self):
		return self.name

class Cue(models.Model):
	keyword = models.CharField(max_length=200)
	stream = models.ForeignKey(Stream, null=True, blank = True)

	def __unicode__(self):
		return self.keyword

ACTIONS = (
		("dmx", "dmx"),
		("arduino", "arduino"),
		("delay", "delay"),
		("osc", "osc"),
		("ouija", "ouija"),
	)

class Action(models.Model):
	cue = models.ForeignKey(Cue)
	order = models.IntegerField()

	actionType = models.CharField(max_length=20,
                              choices=ACTIONS)
	channel = models.IntegerField(blank = True, default = -1)
	value = models.IntegerField(blank = True, default = -1)
	address = models.CharField(max_length=200,blank = True)
	typetag = models.CharField(max_length=10,blank = True)
	textValue = models.CharField(max_length=200,blank = True)

	class Meta:
		order_with_respect_to = 'cue'







