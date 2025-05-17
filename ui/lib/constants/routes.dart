
import 'package:flutter/material.dart';


import '../landing_page.dart';
import '../pages/Home_page/home_page.dart';
import '../pages/Profile_Page/edit_name.dart';
import '../pages/Profile_Page/edit_password.dart';
import '../pages/Profile_Page/edit_phone.dart';
import '../pages/Profile_Page/profile_page.dart';
import '../pages/Subscriptions/subscription_page.dart';
import '../pages/auth_pages/forgot_password.dart';
import '../pages/auth_pages/login_page.dart';
import '../pages/auth_pages/sign_up.dart';
import '../pages/auth_pages/verfify_email.dart';
import '../pages/shorts_page/shorts.dart';

const splash_route='/splash/';
//---------auth pages

const login_route='/login/';
const signup_route='/signup/';
const verify_email_route='/verify_email/';
const forgot_password_route='forgot_password/';
//-------after login pages
const landing_route='/landing/';
const home_route='/home/';
const profile_route='/profile/';
const edit_user_name='/edit_user_name/';
const edit_user_ph_no='/edit_user_ph_no/';
const edit_password='/edit_password/';

const shorts_route='/shorts/';
const subscriptions_route='/subscriptions/';
const content_create_route='/content_create/';
const channel_details='/channel_details/';



final Map<String, WidgetBuilder> routes = {
  Landing_page.route_name:(_)=>const Landing_page(),
  HomePage.route_name:(_)=>const HomePage(),
  LoginPage.route_name:(_)=>const LoginPage(),
  SignupPage.route_name:(_)=>const SignupPage(),
  VerifyEmailPage.route_name:(_)=>const VerifyEmailPage(),
  ForgotPassWordPage.route_name:(_)=>const ForgotPassWordPage(),
  ProfilePage.route_name:(_)=>const ProfilePage(),
  EditNameFormPage.route_name:(_)=>const EditNameFormPage(),
  EditPhoneFormPage.route_name:(_)=>const EditPhoneFormPage(),
  EditPasswordPage.route_name:(_)=>EditPasswordPage(),
  ShortsPage.route_name:(_)=>const ShortsPage(),
  SubscriptionPage.route_name:(_)=>const SubscriptionPage(),
};