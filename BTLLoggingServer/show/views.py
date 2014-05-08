from django.shortcuts import render
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import Permission, Group
from django.contrib.contenttypes.models import ContentType
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext, loader
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.core.urlresolvers import reverse
from django.contrib.admin.views.decorators import staff_member_required

from registration.backends.simple.views import RegistrationView

from django.core import serializers

from show.models import *
from show.forms import *
import json
import traceback
from datetime import datetime

import xml.etree.ElementTree as ET

# Create your views here.

@login_required #login_url='/show/login/')#reverse('show.views.user_login'))
def index(request):
	if not hasattr(request.user, 'userprofile') :
		#return HttpResponseRedirect('/users/'+request.user.username)
		return HttpResponseRedirect(reverse('show.views.user', args=(request.user.username,)))
	#latest_show_list = Show.objects.order_by('-date')[:5]
	stream_list = Stream.objects.all()
	template = loader.get_template('index.html')
	context = RequestContext(request, {
		#'latest_show_list': latest_show_list,
		'stream_list' : stream_list,
	})
	return HttpResponse(template.render(context))

@login_required #(login_url='/show/login/')
def user(request, username):
	context = RequestContext(request)
	context["username"] = username
	if request.method == 'POST':
		profile_form = UserProfileForm(data=request.POST)
		if profile_form.is_valid():
			
			# Now sort out the UserProfile instance.
			# Since we need to set the user attribute ourselves, we set commit=False.
			# This delays saving the model until we're ready to avoid integrity problems.
			profile = profile_form.save(commit=False)
			group = profile_form.cleaned_data['group']
			profile.user = request.user

			#show = profile_form.cleaned_data['show']
			#profile.show = Show.objects.get(name=show)

			try:
				group = Group.objects.get(name=group)
				request.user.groups.add(group)
			except Group.DoesNotExist:
				# group should exist, but this is just for safety's sake, it case the improbable should happen
				pass

			profile.credit = 5
			if request.user.has_perm("show.view_secret"):
				profile.upgradeStatus = True
			else:
				profile.upgradeStatus = False
			profile.mouseX = 0.0
			profile.mouseY = 0.0

			# Now we save the UserProfile model instance.
			profile.save()
			request.user.save()
	try:
		request.user.userprofile
		#return render(request, 'users/user_index.html', context)
		return HttpResponseRedirect(reverse('show.views.index'))
		#return HttpResponse(group)
	except Exception, e:
		profile_form = UserProfileForm()
		context["profile_form"] = profile_form
		return render(request, 'users/profile_form.html', context)
	
class Registration(RegistrationView):
    def get_success_url(self, request, user):
        return reverse('show.views.user', args=(user.username,))

def user_login(request):
	# Like before, obtain the context for the user's request.
	context = RequestContext(request)

	# If the request is a HTTP POST, try to pull out the relevant information.
	if request.method == 'POST':
		# Gather the username and password provided by the user.
		# This information is obtained from the login form.
		username = request.POST['username']
		password = request.POST['password']

		# Use Django's machinery to attempt to see if the username/password
		# combination is valid - a User object is returned if it is.
		user = authenticate(username=username, password=password)

		# If we have a User object, the details are correct.
		# If None (Python's way of representing the absence of a value), no user
		# with matching credentials was found.
		if user is not None:
			# Is the account active? It could have been disabled.
			if user.is_active:
				# If the account is valid and active, we can log the user in.
				# We'll send the user back to the homepage.
				login(request, user)
				#return HttpResponseRedirect('/users/'+user.username)	
				return HttpResponseRedirect(reverse('show.views.user', args=(user.username,)))
			else:
				# An inactive account was used - no logging in!
				return HttpResponse("Your Better than life account is disabled.")
		else:
			# Bad login details were provided. So we can't log the user in.
			#print "Invalid login details: {0}, {1}".format(username, password)
			#return HttpResponseRedirect('/accounts/register/')
			return HttpResponseRedirect(reverse('register'))

	# The request is not a HTTP POST, so display the login form.
	# This scenario would most likely be a HTTP GET.
	else:
		# No context variables to pass to the template system, hence the
		# blank dictionary object...
		return render(request, 'users/login.html', context)



@login_required #(login_url='/show/login/')
def user_status(request):
	phase_list = Phase.objects.filter(active=True)
	active_phase = phase_list[0]
	
	status = {}
	status ["name"] = request.user.username
	status ["credit"] = request.user.userprofile.credit
	status ["secret_permission"] = request.user.has_perm("show.view_secret")
	status ["chat_permission"] = request.user.has_perm("show.chat")
	status ["stream_permission"] = request.user.has_perm("show.select_stream")
	status ["group_red"] = request.user.has_perm("show.group_red")
	status ["group_green"] = request.user.has_perm("show.group_green")
	status ["group_blue"] = request.user.has_perm("show.group_blue")
	status ["camera_status"] = active_phase.camera_status
	status ["chat_status"] = active_phase.chat_status
	status ["mouse_move_status"] = active_phase.mouse_move_status
	status ["question_lottery_status"] = active_phase.question_lottery_status
	status ["tommy_cam_status"] = active_phase.tommy_cam_status
	#data = serializers.serialize("json", [request.user])
	return HttpResponse(json.dumps(status), content_type="application/json")

@csrf_exempt
def user_upgrade(request, type):
	# Like before, obtain the context for the user's request.
	context = RequestContext(request)
	#if request.method == 'POST':
		#try:
	if not request.user.has_perm("show."+type) and request.user.userprofile.credit > 0:
		request.user.userprofile.credit -= 1
		request.user.userprofile.upgradeStatus = True
		#content_type = ContentType.objects.get_for_model(UserProfile)
		#permission = Permission.objects.get(content_type=content_type, codename='view_secret')
		try:
			#group = Group.objects.get(name='theholy')
			#request.user.groups.add(group)
			custom_permission = Permission.objects.get(codename=type)
			request.user.user_permissions.add(custom_permission)
			#user.save()
		except Permission.DoesNotExist:
			# group should exist, but this is just for safety's sake, it case the improbable should happen
			pass
		
		logItem = LogItem(user = request.user,
				show = request.user.userprofile.show, 
				date = datetime.now(),
			 	act = request.user.userprofile.show.act,
			 	section = request.user.userprofile.show.section,
			 	category = "UPGRADE", 
			 	content = type)
		logItem.save()

		#request.user.user_permissions.add(permission)
		request.user.userprofile.save()
		request.user.save()

		

		#return HttpResponse(request.user.has_perm("view_secret"))
		#return HttpResponse("permissions "+str([str(x) for x in request.user.user_permissions.all()])+ " "
		#  +str([str(x) for x in request.user.groups.all()])+ " " + str(request.user.has_perm("show.view_secret")))
		#return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.has_perm("show.view_secret")))
		#return HttpResponse(type)
		#return HttpResponseRedirect('/show/status')
		return HttpResponseRedirect(reverse('status'))
	else:
		if request.user.userprofile.credit <= 0 :
			logItem = LogItem(user = request.user,
					show = request.user.userprofile.show, 
				 	act = request.user.userprofile.show.act,
				 	section = request.user.userprofile.show.section,
				 	category = "UPGRADE", 
				 	content = type + " failed due to lack of credit")
			logItem.save()
		else: 
			logItem = LogItem(user = request.user,
					show = request.user.userprofile.show, 
				 	act = request.user.userprofile.show.act,
				 	section = request.user.userprofile.show.section,
				 	category = "UPGRADE", 
				 	content = type + " failed due to already having permission")
			logItem.save()

		#return HttpResponse(type)
		#return HttpResponseRedirect('/show/status')
		return HttpResponseRedirect(reverse('status'))
		#return HttpResponse(request.user.has_perm("view_secret"))
		#return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.has_perm("show.view_secret")))
			#return HttpResponseRedirect('/show/')
			#return HttpResponseRedirect('/users/'+request.user.username)
		#except Exception, e:
		#	profile_form = UserProfileForm()
		#	context["profile_form"] = profile_form
		#	return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.has_perm("view_secret")))
		#	#return HttpResponse(request.user.userprofile.credit)
	#else:
	#	return HttpResponse("can't GET an upgrade")

@csrf_exempt
def mouseMove(request, xpos, ypos):
	context = RequestContext(request)
	if request.method == 'POST':
		try:
			if request.user.has_perm("show.view_secret"):
				request.user.userprofile.mouseX = xpos
				request.user.userprofile.mouseY = ypos
				request.user.userprofile.save()
				request.user.save()
			return HttpResponse('')
			#return HttpResponseRedirect('/show/')
			#return HttpResponseRedirect('/users/'+request.user.username)
		except Exception, e:
			profile_form = UserProfileForm()
			context["profile_form"] = profile_form
			#return HttpResponseRedirect('/users/'+user.username)
			return HttpResponseRedirect(reverse('show.views.user', args=(user.username,)))
			#return HttpResponse(request.user.userprofile.credit)
	return HttpResponse('')

@csrf_exempt
def averageMouse(request):
	x = 0.0
	y = 0.0
	count = 0
	for profile in UserProfile.objects.all():
		x += profile.mouseX
		y += profile.mouseY
		count += 1
	if count > 0:
		x = x/count
		y = y/count
	return HttpResponse(str(x) + ":" + str(y))

@csrf_exempt
def log(request):
	if request.method == 'POST':
		try:
			category = request.readline()
			content = ""
			for line in request.readlines():
				content = content + line
			# request.user.logitem_set.create(show = request.user.show, 
			# 	act = request.user.show.act,
			# 	section = request.user.show.section,
			# 	category = category, 
			# 	content = content)
			logItem = LogItem(user = request.user,
				show = request.user.userprofile.show, 
			 	act = request.user.userprofile.show.act,
				date = datetime.now(),
			 	section = request.user.userprofile.show.section,
			 	category = category, 
			 	content = content)
			request.user.save()
			logItem.save()
			return HttpResponse("logged item " + str(logItem))
		except Exception, e:
			return HttpResponse("error: " + traceback.format_exc())

	else: 
		return HttpResponse("cannot post to the log url")

def logDisplay(request):
	template = loader.get_template('logdisplay.html')
	log_list = LogItem.objects.order_by('-date')
	context = RequestContext(request, {
		'log_list': log_list,
	})
	return HttpResponse(template.render(context))

@login_required #(login_url='/show/login/')
def postShowQuestionnaire(request):
	context = RequestContext(request)
	if request.method == 'POST':
		questionnaire_form = PostShowQuestionnaireForm(request.POST, user = request.user)
		if questionnaire_form.is_valid():
			
			return HttpResponse("thanks")
	else: 
		questionnaire_form = PostShowQuestionnaireForm(user = request.user)
		context["questionnaire"] = questionnaire_form
		return render(request, 'users/PostQuestionnaire.html', context)

def cues(request):
	root = ET.Element("CueList")
	for stream in Stream.objects.all():
		streamEl = ET.SubElement(root, "Stream", {"name" : stream.name, "seid" : str(stream.SEID), "type" : stream.type})
	for cue in Cue.objects.all():
		if cue.stream != None:
			seid = cue.stream.SEID
		else:
			seid = -1
		cueEl = ET.SubElement(root, "Cue", {"name" : cue.keyword, "seid" : str(seid)})
		for action in cue.action_set.all():
			actionType = action.actionType
			attrs = {"type" : action.actionType, "order" : str(action.order)}
			if actionType == "dmx" or actionType == "arduino":
				attrs["channel"] = str(action.channel)
				attrs["value"] = str(action.channel)
			elif actionType == "delay":
				attrs["value"] = str(action.channel)
			elif actionType == "osc":
				attrs["address"] = str(action.address)
				attrs["typetag"] = str(action.typetag)
				attrs["message"] = str(action.textValue)
			actionEl = ET.SubElement(cueEl, "Action", attrs)
	return HttpResponse(ET.tostring(root))

@staff_member_required
def control(request):
	if request.method == 'POST':
		phase_list = Phase.objects.filter(active=True)
		active_phase = phase_list[0]
		for phase in Phase.objects.all():
			phase.active = False
			phase.save()
		if(active_phase != None and active_phase.next_phase != None):
			active_phase.next_phase.active = True
			active_phase.next_phase.save()
			active_phase = active_phase.next_phase
		else:
			Phase.objects.all()[0].active = True
			Phase.objects.all()[0].save()
			active_phase = Phase.objects.all()[0]	

		if active_phase.reset_permissions :
			custom_permission = Permission.objects.get(codename='select_stream')
			for user in User.objects.all():
				user.user_permissions.remove(custom_permission)
			custom_permission = Permission.objects.get(codename='chat')
			for user in User.objects.all():
				user.user_permissions.remove(custom_permission)

		if not active_phase.reset_credit is None:
			for userprofile in UserProfile.objects.all():
				userprofile.credit = active_phase.reset_credit
				userprofile.save()

		if active_phase.camera_status == "unlocked":
			custom_permission = Permission.objects.get(codename='select_stream')
			for user in User.objects.all():
				user.user_permissions.add(custom_permission)
		if active_phase.chat_status == "unlocked":
			custom_permission = Permission.objects.get(codename='chat')
			for user in User.objects.all():
				user.user_permissions.add(custom_permission)
		return HttpResponseRedirect(reverse('show.views.control'))
	elif request.method == 'GET':
		phase_list = Phase.objects.filter(active=True)
		active_phase = phase_list[0]
		
		template = loader.get_template('ControlTemplate.html')
	
		context = RequestContext(request, {
			#'latest_show_list': latest_show_list,
			'phase' : active_phase,
		})
		return HttpResponse(template.render(context))

