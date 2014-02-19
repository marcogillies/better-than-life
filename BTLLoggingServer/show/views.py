from django.shortcuts import render
from django.contrib.auth import authenticate, login
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext, loader
from django.views.decorators.csrf import csrf_exempt

from show.models import *
from show.forms import *

# Create your views here.

def index(request):
	latest_show_list = Show.objects.order_by('-date')[:5]
	template = loader.get_template('index.html')
	context = RequestContext(request, {
		'latest_show_list': latest_show_list,
	})
	return HttpResponse(template.render(context))

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
			profile.upgradeStatus = False

			# Now we save the UserProfile model instance.
			profile.save()
	try:
		request.user.userprofile
		return render(request, 'users/user_index.html', context)
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

@csrf_exempt
def user_upgrade(request):
	# Like before, obtain the context for the user's request.
	context = RequestContext(request)
	if request.method == 'POST':
		try:
			if not request.user.userprofile.upgradeStatus and request.user.userprofile.credit > 0:
				request.user.userprofile.credit -= 1
				request.user.userprofile.upgradeStatus = True
				request.user.userprofile.save()
			return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.userprofile.upgradeStatus))
			#return HttpResponseRedirect('/show/')
			#return HttpResponseRedirect('/users/'+request.user.username)
		except Exception, e:
			profile_form = UserProfileForm()
			context["profile_form"] = profile_form
			return HttpResponse('%i:%i' % (request.user.userprofile.credit,request.user.userprofile.upgradeStatus))
			#return HttpResponse(request.user.userprofile.credit)
	else:
		return HttpResponse("can't GET an upgrade")


