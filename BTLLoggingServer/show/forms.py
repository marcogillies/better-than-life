from django import forms
from show.models import UserProfile, Show


class UserProfileForm(forms.ModelForm):
    #subject = forms.CharField(max_length=100)
    #message = forms.CharField()
    #sender = forms.EmailField()
    #cc_myself = forms.BooleanField(required=False)
    group = forms.ChoiceField(choices = (('red', 'red'),
    									  ('green', 'green'),
    									  ('blue', 'blue'),
    									  ))
    myshow = forms.ChoiceField(choices = ((s.name, s.name) for s in Show.objects.all()))
    #myshow = forms.ChoiceField(choices = ((name, name) for name in ["one", "two"]))

    class Meta:
        model = UserProfile
        fields = ('colour',)