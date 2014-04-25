from django.shortcuts import render
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import Permission, Group
from django.contrib.contenttypes.models import ContentType
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext, loader
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required

from django.core import serializers

from show.models import *
from show.forms import *
import json

# Create your views here.

@login_required(login_url='/show/login/')
def index(request):
	latest_show_list = Show.objects.order_by('-date')[:5]
	template = loader.get_template('index.html')
	context = RequestContext(request, {
		'latest_show_list': latest_show_list,
	})
	return HttpResponse(template.render(context))

@login_required(login_url='/show/login/')
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
			profile.user = request.user

			profile.credit = 5
			if request.user.has_perm("show.view_secret"):
				profile.upgradeStatus = True
			else:
				profile.upgradeStatus = False
			profile.mouseX = 0.0
			profile.mouseY = 0.0

			# Now we save the UserProfile model instance.
			profile.save()
	try:
		request.user.userprofile
		#return render(request, 'users/user_index.html', context)
		return HttpResponseRedirect('/show/')
	except Exception, e:
		profile_form = UserProfileForm()
		context["profile_form"] = profile_form
		return render(request, 'users/profile_form.html', context)
	

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
				return HttpResponseRedirect('/users/'+user.username)
			else:
				# An inactive account was used - no logging in!
				return HttpResponse("Your Better than life account is disabled.")
		else:
			# Bad login details were provided. So we can't log the user in.
			print "Invalid login details: {0}, {1}".format(username, password)
			return HttpResponseRedirect('/accounts/register/')

	# The request is not a HTTP POST, so display the login form.
	# This scenario would most likely be a HTTP GET.
	else:
		# No context variables to pass to the template system, hence the
		# blank dictionary object...
		return render(request, 'users/login.html', context)


@login_required(login_url='/show/login/')
def user_status(request):
	status = {}
	status ["name"] = request.user.username
	status ["credit"] = request.user.userprofile.credit
	status ["secret_permission"] = request.user.has_perm("show.view_secret")
	status ["chat_permission"] = request.user.has_perm("show.chat")
	status ["stream_permission"] = request.user.has_perm("show.select_stream")
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
		 
		#request.user.user_permissions.add(permission)
		request.user.userprofile.save()
		request.user.save()
		#return HttpResponse(request.user.has_perm("view_secret"))
		#return HttpResponse("permissions "+str([str(x) for x in request.user.user_permissions.all()])+ " "
		#  +str([str(x) for x in request.user.groups.all()])+ " " + str(request.user.has_perm("show.view_secret")))
		#return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.has_perm("show.view_secret")))
		#return HttpResponse(type)
		return HttpResponseRedirect('/show/status')
	else:
		#return HttpResponse(type)
		return HttpResponseRedirect('/show/status')
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
			return HttpResponseRedirect('/users/'+user.username)
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
		category = request.readline()
		content = ""
		for line in request.readlines():
			content = content + line
		request.user.logitem_set.create(category = category, content = content)
		request.user.save()
	return HttpResponse("")
