from django import forms
from show.models import UserProfile


class UserProfileForm(forms.ModelForm):
    #subject = forms.CharField(max_length=100)
    #message = forms.CharField()
    #sender = forms.EmailField()
    #cc_myself = forms.BooleanField(required=False)
    group = forms.ChoiceField(choices = (('red', 'red'),
    									  ('green', 'green'),
    									  ('blue', 'blue'),
    									  ))
    class Meta:
        model = UserProfile
        fields = ('colour',)