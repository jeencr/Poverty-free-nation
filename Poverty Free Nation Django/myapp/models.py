from django.db import models

# Create your models here.
from django.db import models
from django.contrib.auth.models import User




class SkillCenterProfile(models.Model):

    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    address = models.TextField()
    phone = models.CharField(max_length=15)
    approval_status = models.CharField(max_length=100, default='pending')
    email = models.CharField(max_length=100)
    photo = models.ImageField()
    

class CompanyProfile(models.Model):
    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    company_name = models.CharField(max_length=255)
    address = models.TextField()
    phone = models.CharField(max_length=15, blank=True, null=True)
    approval_status = models.CharField(max_length=15, default='pending')


class NormalUser(models.Model):
    LOGIN = models.OneToOneField(User, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=15, blank=True, null=True)
    email = models.CharField(max_length=100)
    address = models.TextField(blank=True, null=True)
    
    

class Resume(models.Model):
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    resume = models.FileField()


class Program(models.Model):
    skill_center = models.ForeignKey(SkillCenterProfile, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField()
    start_date = models.DateField()
    end_date = models.DateField()



class ProgramVideo(models.Model):
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    video = models.FileField(upload_to='videos/')
    title = models.CharField(max_length=255)
    uploaded_at = models.DateTimeField(auto_now_add=True)


class ProgramClass(models.Model):
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    google_meet_link = models.URLField()
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()


class ProgramReview(models.Model):
    program = models.ForeignKey(Program, on_delete=models.CASCADE)
    user = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    rating = models.PositiveSmallIntegerField()
    review = models.TextField()
    date = models.DateField()


class Vacancy(models.Model):
    company = models.ForeignKey(CompanyProfile, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField()
    requirements = models.TextField()
    status = models.CharField(max_length=20, default='open')  # open/closed


class Application(models.Model):
    vacancy = models.ForeignKey(Vacancy, on_delete=models.CASCADE)
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    Resume = models.ForeignKey(Resume, on_delete=models.CASCADE)
    status = models.CharField(max_length=10, default='applied')
    applied_at = models.DateTimeField(auto_now_add=True)


class AppReview(models.Model):
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    rating = models.PositiveSmallIntegerField()
    review = models.TextField()
    Date = models.DateField(auto_now_add=True)


class Complaint(models.Model):
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    complaint_text = models.TextField()
    reply_text = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=20, default='pending')  # pending/replied


class CrowdFundingRequest(models.Model):
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    description = models.TextField()
    amount_needed = models.IntegerField()
    current_amount = models.IntegerField()
    status = models.CharField(max_length=10, default='pending')
    Date = models.DateTimeField(auto_now_add=True)


class Donation(models.Model):
    request = models.ForeignKey(CrowdFundingRequest, on_delete=models.CASCADE)
    donor = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    donated_at = models.DateTimeField(auto_now_add=True)


class HelpRequest(models.Model):
    user = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    message = models.TextField()
    status = models.CharField(max_length=20, default='pending')  # pending/resolved
    created_at = models.DateTimeField(auto_now_add=True)


class HelpResponse(models.Model):
    help_request = models.ForeignKey(HelpRequest, on_delete=models.CASCADE)
    responder = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    willingness_message = models.TextField()
    responded_at = models.DateTimeField(auto_now_add=True)


class Notification(models.Model):
    NormalUser = models.ForeignKey(NormalUser, on_delete=models.CASCADE)
    message = models.TextField()
    Vacancy = models.ForeignKey(Vacancy, on_delete=models.CASCADE)
    read_status = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
