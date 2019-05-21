<?php
/*
Plugin Name: SI CAPTCHA Anti-Spam
Plugin URI: http://www.642weather.com/weather/scripts-wordpress-captcha.php
Description: Adds CAPTCHA anti-spam methods to WordPress on the comment form, registration form, login, or all. This prevents spam from automated bots. Also is WPMU and BuddyPress compatible. <a href="plugins.php?page=si-captcha-for-wordpress/si-captcha.php">Settings</a> | <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=6105441">Donate</a>
Version: 2.5.2
Author: Mike Challis
Author URI: http://www.642weather.com/weather/scripts.php
*/

/*  Copyright (C) 2008-2009 Mike Challis  (http://www.642weather.com/weather/contact_us.php)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

// settings get deleted when plugin is deleted from admin plugins page
// this must be outside the class or it does not work
function si_captcha_unset_options() {

   if (basename(dirname(__FILE__)) != "mu-plugins")
      delete_option('si_captcha');
}

if (!class_exists('siCaptcha')) {

 class siCaptcha {

function si_captcha_add_tabs() {
   global $wpmu;

   if ($wpmu == 1 && function_exists('is_site_admin') && is_site_admin()) {
		add_submenu_page('wpmu-admin.php', __('SI Captcha Options', 'si-captcha'), __('SI Captcha Options', 'si-captcha'), 'manage_options', __FILE__,array(&$this,'si_captcha_options_page'));
		add_options_page( __('SI Captcha Options', 'si-captcha'), __('SI Captcha Options', 'si-captcha'), 'manage_options', __FILE__,array(&$this,'si_captcha_options_page'));
   }
   else if ($wpmu != 1) {
		add_submenu_page('plugins.php', __('SI Captcha Options', 'si-captcha'), __('SI Captcha Options', 'si-captcha'), 'manage_options', __FILE__,array(&$this,'si_captcha_options_page'));
   }
}

function si_captcha_get_options() {
  global $wpmu, $si_captcha_opt, $si_captcha_option_defaults;

  $si_captcha_option_defaults = array(
         'si_captcha_donated' => 'false',
         'si_captcha_captcha_difficulty' => 'medium',
         'si_captcha_perm' => 'true',
         'si_captcha_perm_level' => 'read',
         'si_captcha_comment' => 'true',
         'si_captcha_comment_class' => '',
         'si_captcha_login' => 'false',
         'si_captcha_register' => 'true',
         'si_captcha_rearrange' => 'false',
         'si_captcha_enable_audio' => 'true',
         'si_captcha_enable_audio_flash' => 'false',
         'si_captcha_captcha_small' => 'false',
         'si_captcha_no_trans' => 'false',
         'si_captcha_aria_required' => 'false',
         'si_captcha_captcha_div_style' =>   'display:block;',
         'si_captcha_captcha_image_style' => 'border-style:none; margin:0; padding-right:5px; float:left;',
         'si_captcha_audio_image_style' =>   'border-style:none; margin:0; vertical-align:top;',
         'si_captcha_refresh_image_style' => 'border-style:none; margin:0; vertical-align:bottom;',
         'si_captcha_label_captcha' =>    '',
         'si_captcha_tooltip_captcha' =>  '',
         'si_captcha_tooltip_audio' =>    '',
         'si_captcha_tooltip_refresh' =>  '',
  );

  // upgrade path from old version
  if ($wpmu != 1 && !get_option('si_captcha') && get_option('si_captcha_comment')) {
    // just now updating, migrate settings
    $si_captcha_option_defaults = $this->si_captcha_migrate($si_captcha_option_defaults);
  }

  // install the option defaults
  if ($wpmu == 1) {
        if( !get_site_option('si_captcha') ) {
          add_site_option('si_captcha', $si_captcha_option_defaults, '', 'yes');
        }
  }else{
        add_option('si_captcha', $si_captcha_option_defaults, '', 'yes');
  }

  // get the options from the database
  if ($wpmu == 1)
   $si_captcha_opt = get_site_option('si_captcha'); // get the options from the database
  else
   $si_captcha_opt = get_option('si_captcha');

  // array merge incase this version has added new options
  $si_captcha_opt = array_merge($si_captcha_option_defaults, $si_captcha_opt);

  // strip slashes on get options array
  foreach($si_captcha_opt as $key => $val) {
           $si_captcha_opt[$key] = $this->si_stripslashes($val);
  }

  if ($si_captcha_opt['si_captcha_captcha_image_style'] == '' && $si_captcha_opt['si_captcha_audio_image_style'] == '') {
     // if default styles are missing, reset styles
     $style_resets_arr = array('si_captcha_captcha_div_style','si_captcha_captcha_image_style','si_captcha_audio_image_style','si_captcha_refresh_image_style');
     foreach($style_resets_arr as $style_reset) {
           $si_captcha_opt[$style_reset] = $si_captcha_option_defaults[$style_reset];
     }
  }

    if ( defined('XMLRPC_REQUEST') && XMLRPC_REQUEST )
      $si_captcha_opt['si_captcha_login'] = 'false'; // disable captcha on xmlrpc connections

} // end function si_captcha_get_options

function si_captcha_migrate($si_captcha_option_defaults) {
  // read the options from the prior version
   $new_options = array ();
   foreach($si_captcha_option_defaults as $key => $val) {
      $new_options[$key] = get_option( "$key" );
      // now delete the options from the prior version
      delete_option("$key");
   }
   // now the old settings will carry over to the new version
   return $new_options;
} // end function si_captcha_migrate

function si_captcha_options_page() {
  global $wpmu, $si_captcha_path, $si_captcha_url, $si_captcha_opt, $si_captcha_option_defaults;

  $si_captcha_admin_path = str_replace('/captcha-secureimage','',$si_captcha_path);
  if ($wpmu == 1)
     $si_captcha_admin_path = 'si-captcha-for-wordpress';
  require_once($si_captcha_admin_path . '/si-captcha-admin.php');

}// end function si_captcha_options_page

function si_captcha_perm_dropdown($select_name, $checked_value='') {
        // choices: Display text => permission_level
        $choices = array (
                 __('All registered users', 'si-captcha') => 'read',
                 __('Edit posts', 'si-captcha') => 'edit_posts',
                 __('Publish Posts', 'si-captcha') => 'publish_posts',
                 __('Moderate Comments', 'si-captcha') => 'moderate_comments',
                 __('Administer site', 'si-captcha') => 'level_10'
                 );
        // print the <select> and loop through <options>
        echo '<select name="' . $select_name . '" id="' . $select_name . '">' . "\n";
        foreach ($choices as $text => $capability) :
                if ($capability == $checked_value) $checked = ' selected="selected" ';
                echo "\t". '<option value="' . $capability . '"' . $checked . ">$text</option> \n";
                $checked = '';
        endforeach;
        echo "\t</select>\n";
 } // end function si_captcha_perm_dropdown

function si_captcha_check_requires() {
  global $si_captcha_path;

  $ok = 'ok';
  // Test for some required things, print error message if not OK.
  if ( !extension_loaded('gd') || !function_exists('gd_info') ) {
       echo '<p style="color:maroon">'.__('ERROR: si-captcha.php plugin says GD image support not detected in PHP!', 'si-captcha').'</p>';
       echo '<p>'.__('Contact your web host and ask them why GD image support is not enabled for PHP.', 'si-captcha').'</p>';
      $ok = 'no';
  }
  if ( !function_exists('imagepng') ) {
       echo '<p style="color:maroon">'.__('ERROR: si-captcha.php plugin says imagepng function not detected in PHP!', 'si-captcha').'</p>';
       echo '<p>'.__('Contact your web host and ask them why imagepng function is not enabled for PHP.', 'si-captcha').'</p>';
      $ok = 'no';
  }
  if ( !@strtolower(ini_get('safe_mode')) == 'on' && !file_exists("$si_captcha_path/securimage.php") ) {
       echo '<p style="color:maroon">'.__('ERROR: si-captcha.php plugin says captcha_library not found.', 'si-captcha').'</p>';
       $ok = 'no';
  }
  if ($ok == 'no')  return false;
  return true;
} // end function si_captcha_check_requires

// this function adds the captcha to the comment form
function si_captcha_comment_form() {
    global $user_ID, $si_captcha_url, $si_captcha_opt;

    // skip the captcha if user is loggged in and the settings allow
    if (isset($user_ID) && intval($user_ID) > 0 && $si_captcha_opt['si_captcha_perm'] == 'true') {
       // skip the CAPTCHA display if the minimum capability is met
       if ( current_user_can( $si_captcha_opt['si_captcha_perm_level'] ) ) {
               // skip capthca
               return true;
       }
    }

// the captch html
echo '
<div style="'.$si_captcha_opt['si_captcha_captcha_div_style'].'" id="captchaImgDiv">
';

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - comment form
echo '
<div style="display:block; padding-top:5px;" id="captchaInputDiv">';

 if ( function_exists('bp_loaded') ) { // buddypress

echo ' <label for="captcha_code"><small>';
 echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
 echo '</small></label>';

echo '<input type="text" value="" name="captcha_code" id="captcha_code" tabindex="4" '.$si_aria_required.' style="width:65px;" ';

if ($si_captcha_opt['si_captcha_comment_class'] != '') {
  echo 'class="'.$si_captcha_opt['si_captcha_comment_class'].'" ';
}
echo '/>';

 } else {   // regular WP

echo '<input type="text" value="" name="captcha_code" id="captcha_code" tabindex="4" '.$si_aria_required.' style="width:65px;" ';

if ($si_captcha_opt['si_captcha_comment_class'] != '') {
  echo 'class="'.$si_captcha_opt['si_captcha_comment_class'].'" ';
}
echo '/>
 <label for="captcha_code"><small>';
 echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
 echo '</small></label>';

 }
echo ' </div>
<div style="width: 250px; height: 55px; padding-top:10px;">';
$this->si_captcha_captcha_html('si_image_com','com');
echo '</div>
</div>
';


// rearrange submit button display order
if ($si_captcha_opt['si_captcha_rearrange'] == 'true') {
     print  <<<EOT
      <script type='text/javascript'>
          var sUrlInput = document.getElementById("url");
                  var oParent = sUrlInput.parentNode;
          var sSubstitue = document.getElementById("captchaImgDiv");
                  oParent.appendChild(sSubstitue, sUrlInput);
      </script>
            <noscript>
          <style type='text/css'>#submit {display:none;}</style><br />
EOT;
  echo '           <input name="submit" type="submit" id="submit-alt" tabindex="6" value="'.__('Submit Comment', 'si-captcha').'" />
          </noscript>
  ';

}
}else{
 echo '</div>';
}
    return true;
} // end function si_captcha_comment_form


// this function adds the captcha to the comment form WP3
function si_captcha_comment_form_wp3() {
    global $user_ID, $si_captcha_url, $si_captcha_opt;

    // skip the captcha if user is loggged in and the settings allow
    if (isset($user_ID) && intval($user_ID) > 0 && $si_captcha_opt['si_captcha_perm'] == 'true') {
       // skip the CAPTCHA display if the minimum capability is met
       if ( current_user_can( $si_captcha_opt['si_captcha_perm_level'] ) ) {
               // skip capthca
               return true;
       }
    }

// the captch html
// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - comment form
echo '<p';
if ($si_captcha_opt['si_captcha_comment_class'] != '') {
  echo ' class="'.$si_captcha_opt['si_captcha_comment_class'].'"';
}
echo '><label for="captcha_code">';
echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
echo '</label><span class="required">*</span>
<input id="captcha_code" name="captcha_code" type="text" size="6" style="width:65px;" ' . $si_aria_required . ' /></p>';

echo '
<div style="width: 250px; height: 55px; padding-top:10px;">';
$this->si_captcha_captcha_html('si_image_com','com');
echo '</div>
<br />
';
}
    // prevent double captcha fields
    remove_action('comment_form', array(&$this, 'si_captcha_comment_form'), 1);

    return true;
} // end function si_captcha_comment_form_wp3

// this function adds the captcha to the login form
function si_captcha_login_form() {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_login'] != 'true') {
        return true; // captcha setting is disabled for login
   }

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - login form
echo '
<p>
 <label>';
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '<br />
<input type="text" name="captcha_code" id="captcha_code" class="input" value="" size="12" tabindex="30" '.$si_aria_required.'
    style="font-size: 24px;
	width: 97%;
	padding: 3px;
	margin-top: 2px;
	margin-right: 6px;
	margin-bottom: 16px;
	border: 1px solid #e5e5e5;
	background: #fbfbfb;"
    /></label>
</p>
<div style="width:250px; height:55px;">';
$this->si_captcha_captcha_html('si_image_login','log');
echo '</div>

<br />
';
}

  return true;

} //  end function si_captcha_login_form


// this function adds the captcha to the login bar form of all buddypress versions
function si_captcha_bp_login_form() {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_login'] != 'true') {
        return true; // captcha setting is disabled for login
   }

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - buddypress login form
echo '
<div style="width:440px; height:45px">';
$this->si_captcha_captcha_html('si_image_login','log');
echo '<input type="text" value="" name="captcha_code" id="captcha_code" class="input" '.$si_aria_required.' style="width:65px;" />
         <label for="captcha_code">';
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '</label>
</div>
</div>
';
}

  return true;

} //  end function si_captcha_bp_login_form

// this function adds the captcha to the login sidebar form of all buddypress versions
function si_captcha_bp_login_sidebar_form() {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_login'] != 'true') {
        return true; // captcha setting is disabled for login
   }

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - buddypress sidebar login form
echo '
<div style="width:250px; height:100px">';
echo '
    <label for="captcha_code">';
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '</label>
<input type="text" value="" name="captcha_code" id="captcha_code" class="input" '.$si_aria_required.' style="width:65px;" />
<br />
';
  $this->si_captcha_captcha_html('si_image_side_login','log');
echo '</div>
</div>
';
}

  return true;

} //  end function si_captcha_bp_login_sidebar_form


// this function adds the captcha to the register form
function si_captcha_register_form() {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_register'] != 'true') {
        return true; // captcha setting is disabled for registration
   }

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - register form
echo '
<p>
 <label>';
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '<br />
<input type="text" value="" name="captcha_code" id="captcha_code" class="input" tabindex="30" '.$si_aria_required.'
style="font-size: 24px;
	width: 97%;
	padding: 3px;
	margin-top: 2px;
	margin-right: 6px;
	margin-bottom: 16px;
	border: 1px solid #e5e5e5;
	background: #fbfbfb;"
/></label>
</p>
<div style="width: 250px;  height: 55px">';
$this->si_captcha_captcha_html('si_image_reg','reg');
echo '</div>
<br />
';
}

  return true;
} // end function si_captcha_register_form

// for wpmu and buddypress before 1.1
function si_captcha_wpmu_signup_form( $errors ) {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_register'] != 'true') {
        return true; // captcha setting is disabled for registration
   }
   $error = $errors->get_error_message('captcha');

   if( isset($error) && $error != '') {
     echo '<p class="error">' . $error . '</p>';
   }
// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - wpmu register form
echo '
<label for="captcha_code">';
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '</label>
<input type="text" value="" name="captcha_code" id="captcha_code" '.$si_aria_required.' style="width:65px;" />

<div style="width: 250px;  height: 55px">';
$this->si_captcha_captcha_html('si_image_reg','reg');
echo '</div>

';
}
} // end function si_captcha_wpmu_signup_form

// for buddypress 1.1+ only
// hooks into register.php do_action( 'bp_before_registration_submit_buttons' )
// and bp-core-signup.php add_action( 'bp_' . $fieldname . '_errors', ...
function si_captcha_bp_signup_form() {
   global $si_captcha_url, $si_captcha_opt;

   if ($si_captcha_opt['si_captcha_register'] != 'true') {
        return true; // captcha setting is disabled for registration
   }

// Test for some required things, print error message right here if not OK.
if ($this->si_captcha_check_requires()) {

  $si_aria_required = ($si_captcha_opt['si_captcha_aria_required'] == 'true') ? ' aria-required="true" ' : '';

// the captcha html - buddypress 1.1 register form
echo '
<div class="register-section" style="clear:left; margin-top:-10px;">
<label for="captcha_code">';
  do_action( 'bp_captcha_code_errors' );
  echo ($si_captcha_opt['si_captcha_label_captcha'] != '') ? esc_html( $si_captcha_opt['si_captcha_label_captcha'] ) : esc_html( __('CAPTCHA Code', 'si-captcha'));
  echo '</label>
<input type="text" value="" name="captcha_code" id="captcha_code" '.$si_aria_required.' style="width:65px;" />

<div style="width: 250px;  height: 55px">';
$this->si_captcha_captcha_html('si_image_reg','reg');
echo '</div>
</div>

';
}
} // end function si_captcha_wpmu_signup_form

// this function checks the captcha posted with registration on BuddyPress 1.1+
// hooks into bp-core-signup.php do_action( 'bp_signup_validate' );
function si_captcha_bp_signup_validate() {
   global $bp, $si_captcha_path;

    if (!isset($_SESSION['securimage_code_si_reg']) || empty($_SESSION['securimage_code_si_reg'])) {
          $bp->signup->errors['captcha_code'] = __('Could not read CAPTCHA cookie. Make sure you have cookies enabled and not blocking in your web browser settings. Or another plugin is conflicting. See plugin FAQ.', 'si-captcha');
          return;
   }else{
      if (empty($_POST['captcha_code']) || $_POST['captcha_code'] == '') {
                $bp->signup->errors['captcha_code'] = __('Please complete the CAPTCHA.', 'si-captcha');
                return;
      } else {
        $captcha_code = trim(strip_tags($_POST['captcha_code']));
      }
      require_once "$si_captcha_path/securimage.php";
      $img = new Securimage();
      $img->form_id = 'reg'; // makes compatible with multi-forms on same page
      $valid = $img->check("$captcha_code");
      // Check, that the right CAPTCHA password has been entered, display an error message otherwise.
      if($valid == true) {
          // ok can continue
      } else {
          $bp->signup->errors['captcha_code'] = __('That CAPTCHA was incorrect. Make sure you have not disabled cookies.', 'si-captcha');
          return;
      }
   }
   return;
} // end function si_captcha_bp_signup_validate

// this function checks the captcha posted with registration on wpmu and buddypress before 1.1
function si_captcha_wpmu_signup_post($errors) {
   global $si_captcha_path;

 if ($_POST['stage'] == 'validate-user-signup') {
    if (!isset($_SESSION['securimage_code_si_reg']) || empty($_SESSION['securimage_code_si_reg'])) {
          $errors['errors']->add('captcha', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Could not read CAPTCHA cookie. Make sure you have cookies enabled and not blocking in your web browser settings. Or another plugin is conflicting. See plugin FAQ.', 'si-captcha'));
          return $errors;
   }else{
      if (empty($_POST['captcha_code']) || $_POST['captcha_code'] == '') {
                $errors['errors']->add('captcha', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Please complete the CAPTCHA.', 'si-captcha'));
                return $errors;
      } else {
        $captcha_code = trim(strip_tags($_POST['captcha_code']));
      }
      require_once "$si_captcha_path/securimage.php";
      $img = new Securimage();
      $img->form_id = 'reg'; // makes compatible with multi-forms on same page
      $valid = $img->check("$captcha_code");
      // Check, that the right CAPTCHA password has been entered, display an error message otherwise.
      if($valid == true) {
          // ok can continue
      } else {
          $errors['errors']->add('captcha', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('That CAPTCHA was incorrect. Make sure you have not disabled cookies.', 'si-captcha'));
      }
   }
 }
   return($errors);

} // end function si_captcha_wpmu_signup_post

// this function checks the captcha posted with registration
function si_captcha_register_post($errors) {
   global $si_captcha_path;

   if (!isset($_SESSION['securimage_code_si_reg']) || empty($_SESSION['securimage_code_si_reg'])) {
          $errors->add('captcha_no_cookie', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Could not read CAPTCHA cookie. Make sure you have cookies enabled and not blocking in your web browser settings. Or another plugin is conflicting. See plugin FAQ.', 'si-captcha'));
          return $errors;
   }else{
      if (empty($_POST['captcha_code']) || $_POST['captcha_code'] == '') {
                $errors->add('captcha_blank', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Please complete the CAPTCHA.', 'si-captcha'));
                return $errors;
      } else {
        $captcha_code = trim(strip_tags($_POST['captcha_code']));
      }

      require_once "$si_captcha_path/securimage.php";
      $img = new Securimage();
      $img->form_id = 'reg'; // makes compatible with multi-forms on same page
      $valid = $img->check("$captcha_code");
      // Check, that the right CAPTCHA password has been entered, display an error message otherwise.
      if($valid == true) {
          // ok can continue
      } else {
          $errors->add('captcha_wrong', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('That CAPTCHA was incorrect. Make sure you have not disabled cookies.', 'si-captcha'));
      }
   }
   return($errors);
} // end function si_captcha_register_post

// this function checks the captcha posted with the comment
function si_captcha_comment_post($comment) {
    global $user_ID, $si_captcha_path, $si_captcha_opt;

    // added for compatibility with WP Wall plugin
    // this does NOT add CAPTCHA to WP Wall plugin,
    // it just prevents the "Error: You did not enter a Captcha phrase." when submitting a WP Wall comment
    if ( function_exists('WPWall_Widget') && isset($_POST['wpwall_comment']) ) {
        // skip capthca
        return $comment;
    }

    // skip the captcha if user is loggged in and the settings allow
    if (isset($user_ID) && intval($user_ID) > 0 && $si_captcha_opt['si_captcha_perm'] == 'true') {
       // skip the CAPTCHA display if the minimum capability is met
       if ( current_user_can( $si_captcha_opt['si_captcha_perm_level'] ) ) {
               // skip capthca
               return $comment;
        }
    }

    // Skip captcha for trackback or pingback
    if ( $comment['comment_type'] != '' && $comment['comment_type'] != 'comment' ) {
               // skip capthca
               return $comment;
    }
    if (!isset($_SESSION['securimage_code_si_com']) || empty($_SESSION['securimage_code_si_com'])) {
          wp_die( '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Could not read CAPTCHA cookie. Make sure you have cookies enabled and not blocking in your web browser settings. Or another plugin is conflicting. See plugin FAQ.', 'si-captcha'));
    }else{
       if (empty($_POST['captcha_code']) || $_POST['captcha_code'] == '') {
           wp_die( __('Error: You did not enter a Captcha phrase. Press your browsers back button and try again.', 'si-captcha'));
       }
       $captcha_code = trim(strip_tags($_POST['captcha_code']));
       require_once "$si_captcha_path/securimage.php";
       $img = new Securimage();
       $img->form_id = 'com'; // makes compatible with multi-forms on same page
       $valid = $img->check("$captcha_code");
       // Check, that the right CAPTCHA password has been entered, display an error message otherwise.
       if($valid == true) {
           // ok can continue
           return($comment);
       } else {
           wp_die( __('Error: You entered in the wrong Captcha phrase. Press your browsers back button and try again.', 'si-captcha'));
       }
    }

} // end function si_captcha_comment_post


function si_captcha_captcha_html($label = 'si_image', $form_id = 'com') {
  global $si_captcha_url, $si_captcha_opt;

  $captcha_level_file = 'securimage_show_medium.php';
  if ($si_captcha_opt['si_captcha_captcha_difficulty'] == 'low') {
      $captcha_level_file = 'securimage_show_low.php';
  } else if ($si_captcha_opt['si_captcha_captcha_difficulty'] == 'high') {
      $captcha_level_file = 'securimage_show_high.php';
  }
  if ($si_captcha_opt['si_captcha_no_trans'] == 'true')
     $captcha_level_file = 'securimage_show_no_trans.php';

  echo '<img id="'.$label.'" ';
  //captcha style="border-style:none; margin:0; padding-right:5px; float:left;"
  echo ($si_captcha_opt['si_captcha_captcha_image_style'] != '') ? 'style="' . esc_attr( $si_captcha_opt['si_captcha_captcha_image_style'] ).'"' : '';
  echo ' src="'.$si_captcha_url.'/'.$captcha_level_file.'?';
         if($si_captcha_opt['si_captcha_captcha_small'] == 'true')
             echo 'si_sm_captcha=1&amp;';
  echo 'si_form_id='.$form_id.'&amp;sid='.md5(uniqid(time())).'" alt="';
  echo ($si_captcha_opt['si_captcha_tooltip_captcha'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_captcha'] ) : esc_attr(__('CAPTCHA Image', 'si-captcha'));
  echo '" title="';
  echo ($si_captcha_opt['si_captcha_tooltip_captcha'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_captcha'] ) : esc_attr(__('CAPTCHA Image', 'si-captcha'));
  echo '" />';

  if($si_captcha_opt['si_captcha_enable_audio'] == 'true') {
     if($si_captcha_opt['si_captcha_enable_audio_flash'] == 'true') {
        $parseUrl = parse_url($si_captcha_url);
        $secureimage_url = $parseUrl['path'];
        echo '
        <object type="application/x-shockwave-flash"
                data="'.$secureimage_url.'/securimage_play.swf?si_form_id='.$form_id.'&amp;bgColor1=#8E9CB6&amp;bgColor2=#fff&amp;iconColor=#000&amp;roundedCorner=5&amp;audio='.$secureimage_url.'/securimage_play.php?si_form_id='.$form_id.'"
                id="SecurImage_as3" width="19" height="19" align="middle">
			    <param name="allowScriptAccess" value="sameDomain" />
			    <param name="allowFullScreen" value="false" />
			    <param name="movie" value="'.$secureimage_url.'/securimage_play.swf?si_form_id='.$form_id.'&amp;bgColor1=#8E9CB6&amp;bgColor2=#fff&amp;iconColor=#000&amp;roundedCorner=5&amp;audio='.$secureimage_url.'/securimage_play.php?si_form_id='.$form_id.'" />
			    <param name="quality" value="high" />
			    <param name="bgcolor" value="#ffffff" />
		</object>
        <br />';
     }else{
        echo '<a href="'.$si_captcha_url.'/securimage_play.php?si_form_id='.$form_id.'" title="';
        echo ($si_captcha_opt['si_captcha_tooltip_audio'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_audio'] ) : esc_attr(__('CAPTCHA Audio', 'si-captcha'));
        echo '">
        <img src="'.$si_captcha_url.'/images/audio_icon.gif" alt="';
        echo ($si_captcha_opt['si_captcha_tooltip_audio'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_audio'] ) : esc_attr(__('CAPTCHA Audio', 'si-captcha'));
        echo  '" ';
        echo ($si_captcha_opt['si_captcha_audio_image_style'] != '') ? 'style="' . esc_attr( $si_captcha_opt['si_captcha_audio_image_style'] ).'"' : '';
        echo ' onclick="this.blur()" /></a><br />';
     }
  }
  echo '<a href="#" title="';
  echo ($si_captcha_opt['si_captcha_tooltip_refresh'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_refresh'] ) : esc_attr(__('Refresh Image', 'si-captcha'));
  echo '" onclick="document.getElementById(\''.$label.'\').src = \''.$si_captcha_url.'/'.$captcha_level_file.'?';
         if($si_captcha_opt['si_captcha_captcha_small'] == 'true')
            echo 'si_sm_captcha=1&amp;';
  echo 'si_form_id='.$form_id.'&amp;sid=\' + Math.random(); return false">
  <img src="'.$si_captcha_url.'/images/refresh.gif" alt="';
  echo ($si_captcha_opt['si_captcha_tooltip_refresh'] != '') ? esc_attr( $si_captcha_opt['si_captcha_tooltip_refresh'] ) : esc_attr(__('Refresh Image', 'si-captcha'));
  echo '" ';
  // refresh style="border-style:none; margin:0; vertical-align:bottom;"
  echo ($si_captcha_opt['si_captcha_refresh_image_style'] != '') ? 'style="' . esc_attr( $si_captcha_opt['si_captcha_refresh_image_style'] ).'"' : '';
  echo ' onclick="this.blur()" /></a>
  ';

} // end function si_captcha_captcha_html

function si_captcha_plugin_action_links( $links, $file ) {
    //Static so we don't call plugin_basename on every plugin row.
	static $this_plugin;
	if ( ! $this_plugin ) $this_plugin = plugin_basename(__FILE__);

	if ( $file == $this_plugin ){
	     $settings_link = '<a href="plugins.php?page=si-captcha-for-wordpress/si-captcha.php">' . esc_html( __( 'Settings', 'si-captcha' ) ) . '</a>';
	     array_unshift( $links, $settings_link );
    }
	return $links;
} // end function si_captcha_plugin_action_links

function si_captcha_init() {
   global $wpmu;

  if (function_exists('load_plugin_textdomain')) {
     if ($wpmu == 1) {
          load_plugin_textdomain('si-captcha', false, dirname(plugin_basename(__FILE__)).'/si-captcha-for-wordpress/languages' );
     } else {
          load_plugin_textdomain('si-captcha', false, dirname(plugin_basename(__FILE__)).'/languages' );
     }
  }

} // end function si_captcha_init

function si_captcha_start_session() {

   // a PHP session cookie is set so that the captcha can be remembered and function
  // this has to be set before any header output
   //echo "before starting session si captcha";
  if( !isset( $_SESSION ) ) { // play nice with other plugins
   if ( !defined('XMLRPC_REQUEST') ) {
     session_cache_limiter ('private, must-revalidate');
     session_start();
     //echo "session started si captcha";
   }
  }

} // function si_captcha_start_session

function si_wp_authenticate_username_password($user, $username, $password) {
        global $si_captcha_path, $si_captcha_opt;

		if ( is_a($user, 'WP_User') ) { return $user; }

		if ( empty($username) || empty($password) || isset($_POST['captcha_code']) && empty($_POST['captcha_code'])) {
		    $error = new WP_Error();
            
			if ( empty($username) )
				$error->add('empty_username', __('<strong>ERROR</strong>: The username field is empty.'));

			if ( empty($password) )
				$error->add('empty_password', __('<strong>ERROR</strong>: The password field is empty.'));

            if (isset($_POST['captcha_code']) && empty($_POST['captcha_code']))
                $error->add('empty_captcha', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Please complete the CAPTCHA.', 'si-captcha'));

			return $error;
		}

   // begin si captcha check
   if (!isset($_SESSION['securimage_code_si_log']) || empty($_SESSION['securimage_code_si_log'])) {
          return new WP_Error('captcha_error', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('Could not read CAPTCHA cookie. Make sure you have cookies enabled and not blocking in your web browser settings. Or another plugin is conflicting. See plugin FAQ.', 'si-captcha'));
   }else{

      $captcha_code = trim(strip_tags($_POST['captcha_code']));

      require_once "$si_captcha_path/securimage.php";
      $img = new Securimage();
      $img->form_id = 'log'; // makes compatible with multi-forms on same page
      $valid = $img->check("$captcha_code");
      // Check, that the right CAPTCHA password has been entered, display an error message otherwise.
      if($valid == true) {
          // ok can continue
      } else {
          return new WP_Error('captcha_error', '<strong>'.__('ERROR', 'si-captcha').'</strong>: '.__('That CAPTCHA was incorrect. Make sure you have not disabled cookies.', 'si-captcha'));
      }
   }
   // end si captcha check

		$userdata = get_userdatabylogin($username);

		if ( !$userdata ) {
			return new WP_Error('invalid_username', sprintf(__('<strong>ERROR</strong>: Invalid username. <a href="%s" title="Password Lost and Found">Lost your password</a>?'), site_url('wp-login.php?action=lostpassword', 'login')));
		}

		$userdata = apply_filters('wp_authenticate_user', $userdata, $password);
		if ( is_wp_error($userdata) ) {
			return $userdata;
		}

		if ( !wp_check_password($password, $userdata->user_pass, $userdata->ID) ) {
			return new WP_Error('incorrect_password', sprintf(__('<strong>ERROR</strong>: Incorrect password. <a href="%s" title="Password Lost and Found">Lost your password</a>?'), site_url('wp-login.php?action=lostpassword', 'login')));
		}

		$user =  new WP_User($userdata->ID);
		return $user;
}

// functions for form vars
function si_stripslashes($string) {
        if (get_magic_quotes_gpc()) {
                return stripslashes($string);
        } else {
                return $string;
        }
} // end function si_stripslashes


function get_captcha_url_si() {
   global $wpmu;
  // The captcha URL cannot be on a different domain as the site rewrites to or the cookie won't work
  // also the path has to be correct or the image won't load.
  // WP_PLUGIN_URL was not getting the job done! this code should fix it.

  //http://media.example.com/wordpress   WordPress address get_option( 'siteurl' )
  //http://tada.example.com              Blog address      get_option( 'home' )

  //http://example.com/wordpress  WordPress address get_option( 'siteurl' )
  //http://example.com/           Blog address      get_option( 'home' )

  $site_uri = parse_url(get_option('home'));
  $home_uri = parse_url(get_option('siteurl'));

  $si_dir = '/si-captcha-for-wordpress/captcha-secureimage';

  $url  = WP_PLUGIN_URL . $si_dir;

  if ($site_uri['host'] == $home_uri['host']) {
      $url = WP_PLUGIN_URL . $si_dir;
      if ($wpmu == 1)
           $url = get_option('siteurl') . '/' . MUPLUGINDIR . $si_dir;
  } else {
      $url = get_option( 'home' ) . '/' . PLUGINDIR . $si_dir;
      if ($wpmu == 1)
          $url = get_option( 'home' ) . '/' . MUPLUGINDIR . $si_dir;
  }

  // SSL aware: set the type of request (secure or not)
  $request_type = ( isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on' ) ? 'SSL' : 'NONSSL';
  if ($request_type == 'SSL' && !preg_match("#^https#i", $url)) {
    $url = str_replace('http','https',$url);
  }

  return $url;
}

} // end of class
} // end of if class

// backwards compatibility

// Pre-2.8 compatibility
if ( ! function_exists( 'esc_html' ) ) {
	function esc_html( $text ) {
		return wp_specialchars( $text );
	}
}

// Pre-2.8 compatibility
if ( ! function_exists( 'esc_attr' ) ) {
	function esc_attr( $text ) {
		return attribute_escape( $text );
	}
}

if (class_exists("siCaptcha")) {
 $si_image_captcha = new siCaptcha();
}

if (isset($si_image_captcha)) {

// WordPress MU detection
//    0  Regular WordPress installation
//    1  WordPress MU Forced Activated
//    2  WordPress MU Optional Activation

$wpmu = 0;

if (basename(dirname(__FILE__)) == "mu-plugins") // forced activated
   $wpmu = 1;
else if (basename(dirname(__FILE__)) == "si-captcha-for-wordpress" && function_exists('is_site_admin')) // optionally activated
   $wpmu = 2;

  $si_captcha_path = WP_PLUGIN_DIR . '/si-captcha-for-wordpress/captcha-secureimage';
  if ($wpmu == 1) {
     if ( defined( 'MUPLUGINDIR' ) )
         $si_captcha_path = MUPLUGINDIR . '/si-captcha-for-wordpress/captcha-secureimage';
     else
         $si_captcha_path = WP_CONTENT_DIR . '/mu-plugins/si-captcha-for-wordpress/captcha-secureimage';
  }

  $si_captcha_url  = $si_image_captcha->get_captcha_url_si();

  //Actions
  add_action('init', array(&$si_image_captcha, 'si_captcha_init'));

  // buddypress had session error on member and groups pages, so start session here instead of init
  add_action('plugins_loaded', array(&$si_image_captcha, 'si_captcha_start_session'));

    // get the options now
  $si_image_captcha->si_captcha_get_options();

  // si captcha admin options
  add_action('admin_menu', array(&$si_image_captcha,'si_captcha_add_tabs'),1);

  // adds "Settings" link to the plugin action page
  add_filter( 'plugin_action_links', array(&$si_image_captcha,'si_captcha_plugin_action_links'),10,2);

  if ($si_captcha_opt['si_captcha_comment'] == 'true') {

     // for WP 3.0+
     if( $wp_version[0] > 2 ) { // wp 3.0 +
       add_action( 'comment_form_after_fields', array(&$si_image_captcha, 'si_captcha_comment_form_wp3'), 1);
     }

     // for WP before WP 3.0
     add_action('comment_form', array(&$si_image_captcha, 'si_captcha_comment_form'), 1);

     add_filter('preprocess_comment', array(&$si_image_captcha, 'si_captcha_comment_post'), 1);
  }

  if ($si_captcha_opt['si_captcha_register'] == 'true') {
    add_action('register_form', array(&$si_image_captcha, 'si_captcha_register_form'), 1);
    add_filter('registration_errors', array(&$si_image_captcha, 'si_captcha_register_post'), 1);
  }

  if ($wpmu && $si_captcha_opt['si_captcha_register'] == 'true') {
        // for buddypress 1.1 only
    add_action('bp_before_registration_submit_buttons', array( &$si_image_captcha, 'si_captcha_bp_signup_form' ));
        // for buddypress 1.1 only
    add_action('bp_signup_validate', array( &$si_image_captcha, 'si_captcha_bp_signup_validate' ));
        // for wpmu and (buddypress versions before 1.1)
    add_action('signup_extra_fields', array( &$si_image_captcha, 'si_captcha_wpmu_signup_form' ));
        // for wpmu and (buddypress versions before 1.1)
	add_filter('wpmu_validate_user_signup', array( &$si_image_captcha, 'si_captcha_wpmu_signup_post'));
  }

  if ($si_captcha_opt['si_captcha_login'] == 'true') {
    add_action('login_form', array( &$si_image_captcha, 'si_captcha_login_form' ) );
    add_action('bp_login_bar_logged_out', array( &$si_image_captcha, 'si_captcha_bp_login_form' ) );
    add_action('bp_sidebar_login_form', array( &$si_image_captcha, 'si_captcha_bp_login_sidebar_form' ) );
    remove_filter('authenticate', 'wp_authenticate_username_password', 20, 3);
	add_filter('authenticate', array( &$si_image_captcha, 'si_wp_authenticate_username_password'), 20, 3);
  }

  // options deleted when this plugin is deleted in WP 2.7+
  if ( function_exists('register_uninstall_hook') )
     register_uninstall_hook(__FILE__, 'si_captcha_unset_options');
}

?>