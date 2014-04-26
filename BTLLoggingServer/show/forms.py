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
    #myshow = forms.ChoiceField(choices = ((s.name, s.name) for s in Show.objects.all()))
    #myshow = forms.ChoiceField(choices = ((name, name) for name in ["one", "two"]))

    class Meta:
        model = UserProfile
        fields = ('colour','show')

class PostShowQuestionnaireForm (forms.Form):
    def __init__(self, *args, **kwargs):
        user = kwargs.pop('user', 0)
        super(PostShowQuestionnaireForm, self).__init__(*args, **kwargs)

        self.fields["how happy were you with your experience?"] = forms.ChoiceField(widget=forms.RadioSelect(),choices=[(i,i) for i in range(7)])

        for logitem in user.logitem_set.filter(category="UPGRADE"):
            fieldName = "During the {section} section of act {act} you chose to buy a {type}, why did you choose to buy it at that time?".format(section=logitem.section, act=logitem.act, type=logitem.content)
            self.fields[fieldName] = forms.CharField(widget=forms.Textarea)
