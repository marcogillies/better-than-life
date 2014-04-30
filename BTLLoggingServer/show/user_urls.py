from django.conf.urls import patterns, url

from show import views

urlpatterns = patterns('',
    url(r'^(?P<username>\w+)/$', views.user, name='registration_activation_complete')
)