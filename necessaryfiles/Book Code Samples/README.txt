*********************************************************************************
Thank you for downloading the source code for:
"The Web Application Defener's Cookbook: Battling Hackers and Protecting Users".
*********************************************************************************

The source code for the following chapters are included:

Part I: Preparing the Battle Space

Chapter 1  - Application Fortification
			OWASP ModSecurity Core Rule Set (CRS) package v2.2.6.
		  	Download the latest version here: https://github.com/SpiderLabs/owasp-modsecurity-crs

             Recipe 1-1: Real-time Application Profiling
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			modsecurity_crs_40_appsensor_detection_point_3.0_end.conf			appsensor_request_exception_profile.lua

		  Recipe 1-2: Preventing Data Manipulation with Cryptographic Hash Tokens
			recipe-1-2.conf

		  Recipe 1-3: Installing the OWASP ModSecurity Core Rule Set (CRS)			modsecurity_crs_10_setup.conf			modsecurity_crs_20_protocol_violations.conf			modsecurity_crs_21_protocol_anomalies.conf			modsecurity_crs_23_request_limits.conf			modsecurity_crs_30_http_policy.conf			modsecurity_crs_35_bad_robots.conf			modsecurity_crs_40_generic_attacks.conf			modsecurity_crs_41_sql_injection_attacks.conf			modsecurity_crs_41_xss_attacks.conf			modsecurity_crs_45_trojans.conf			modsecurity_crs_47_common_exceptions.conf
			modsecurity_crs_49_inbound_blocking.conf			modsecurity_crs_50_outbound.conf			modsecurity_crs_59_outbound_blocking.conf			modsecurity_crs_60_correlation.conf

		  Recipe 1-4: Integrating Intrusion Detection System Signatures
		  	http://rules.emergingthreats.net/open/snort-2.8.4/rules/emerging-web_specific_apps.rules
			http://rules.emergingthreats.net/open/snort-2.8.4/rules/emerging-web_server.rules
			snort2modsec2.pl

		  Recipe 1-5: Using Bayesian Attack Payload Detection
			osbf-lua
			moonrunner.lua
			modsecurity_crs_48_bayes_analysis.conf			bayes_train_spam.lua			bayes_train_ham.lua			bayes_check_spam.lua

		  Recipe 1-6: Enable Full HTTP Auditing
			recipe-1-6.conf

		  Recipe 1-7: Logging Only Relevant Transactions
			recipe-1-7.conf
			
		  Recipe 1-8: Ignoring Requests for Static Content
			recipe-1-8.conf

		  Recipe 1-9: Obscuring Sensitive Data in Logs
			recipe-1-9.conf

		  Recipe 1-10: Sending Alerts to a Central Log Host using Syslog
			No code provided.

		  Recipe 1-11: Using the ModSecurity AuditConsole
			http://download.jwall.org/AuditConsole/current/


Chapter 2  - Vulnerability Identification and Remediation

		  Recipe 2-1: Passive Vulnerability Identification
			Download vuln data from: http://osvdb.org/
			modsecurity_crs_56_pvi_checks.conf			osvdb.lua
			modsecurity_crs_55_application_defects.conf 

		  Recipe 2-2: Active Vulnerability Identification
			Download code from: http://arachni-scanner.com/

		  Recipe 2-3: Active Vulnerability Identification
			recipe-2-3.conf

		  Recipe 2-4: Automated Scan Result Conversion
			arachni2modsec.pl
			modsecurity_crs_48_virtual_patches.conf 

		  Recipe 2-5: Real-time Resource Assessments and Virtual Patching
			modsecurity_crs_11_avs_traffic.conf
			arachni_integration.lua
			modsecurity_crs_46_known_vulns.conf


Chapter 3  - Poisoned Pawns (Hacker Traps)

		  Recipe 3-1: Adding Honeypot Ports
			recipe-3-1.conf

		  Recipe 3-2: Adding Fake robots.txt Disallow Entries
			recipe-3-2.conf
		  
		  Recipe 3-3: Adding Fake HTML Comments
			recipe-3-3.conf

		  Recipe 3-4: Adding Fake Hidden Form Fields
			recipe-3-4.conf

		  Recipe 3-5: Adding Fake Cookies
			recipe-3-5.conf


Part II: Asymmetric Warfare

Chapter 4  - Reputation and Third-Party Correlation

		  Recipe 4-1: Analyzing the Client's Geographic Location Data
			recipe-4-1.conf

		  Recipe 4-2: Identifying Suspicious Open Proxy Usage
			recipe-4-2.conf

		  Recipe 4-3: Utilizing Real-time Blacklist Lookups (RBLs)
			recipe-4-3.conf

		  Recipe 4-4: Running Your Own RBL
			recipe-4-4.conf

		  Recipe 4-5: Detecting Malicious Links
			recipe-4-5.conf


Chapter 5  - Request Data Analysis

		  Recipe 5-1: Request Body Access
			recipe-5-1.conf

		  Recipe 5-2: Identifying Malformed Request Bodies
			recipe-5-2.conf

		  Recipe 5-3: Normalizing Unicode
			recipe-5-3.conf

		  Recipe 5-4: Identifying Use of Multiple Encodings
			recipe-5-4.conf

		  Recipe 5-5: Identifying Encoding Anomalies
			recipe-5-5.conf

		  Recipe 5-6: Detecting Request Method Anomalies
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			appsensor_request_exception_enforce.lua			appsensor_request_exception_profile.lua

		  Recipe 5-7: Detecting Invalid URI Data
			modsecurity_crs_20_protocol_violations.conf

		  Recipe 5-8: Detecting Request Header Anomalies
			modsecurity_crs_21_protocol_anomalies.conf
			modsecurity_crs_35_bad_robots.conf
			recipe-5-8.conf

		  Recipe 5-9: Detecting Additional Parameters
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			appsensor_request_exception_enforce.lua			appsensor_request_exception_profile.lua

		  Recipe 5-10: Detecting Missing Parameters
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			appsensor_request_exception_enforce.lua			appsensor_request_exception_profile.lua

		  Recipe 5-11: Detecting Duplicate Parameter Names
			modsecurity_crs_40_parameter_pollution.conf

		  Recipe 5-12: Detecting Parameter Payload Size Anomalies
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			appsensor_request_exception_enforce.lua			appsensor_request_exception_profile.lua

		  Recipe 5-13: Detecting Parameter Character Class Anomalies
			modsecurity_crs_40_appsensor_detection_point_2.0_setup.conf			modsecurity_crs_40_appsensor_detection_point_2.1_request_exception.conf			appsensor_request_exception_enforce.lua			appsensor_request_exception_profile.lua


Chapter 6  - Response Data Analysis

		  Recipe 6-1: Detecting Response Header Anomalies
			recipe-6-1.conf
			modsecurity_crs_40_appsensor_detection_point_2.1_response_exception.conf
			appsensor_response_enforce.lua
			appsensor_response_profile.lua
			
		  Recipe 6-2: Detecting Response Header Information Leakages
			recipe-6-2.conf
			
		  Recipe 6-3: Response Body Access
			recipe-6-3.conf

		  Recipe 6-4: Detecting Page Title Changes
			modsecurity_crs_40_appsensor_detection_point_2.1_response_exception.conf
			appsensor_response_enforce.lua
			appsensor_response_profile.lua

		  Recipe 6-5: Detecting Page Size Deviations
			modsecurity_crs_40_appsensor_detection_point_2.1_response_exception.conf
			appsensor_response_enforce.lua
			appsensor_response_profile.lua

		  Recipe 6-6: Detecting Dynamic Content Changes
			modsecurity_crs_40_appsensor_detection_point_2.1_response_exception.conf
			appsensor_response_enforce.lua
			appsensor_response_profile.lua

		  Recipe 6-7: Detecting Source Code Leakages
			modsecurity_crs_50_outbound.conf

		  Recipe 6-8: Detecting Technical Data Leakages
			modsecurity_crs_50_outbound.conf

		  Recipe 6-9: Detecting Abnormal Response Time Intervals
			recipe-6-9.conf

		  Recipe 6-10: Detecting Sensitive User Data Leakages
			modsecurity_crs_25_cc_known.conf

		  Recipe 6-11: Detecting Trojan, Backdoor and WebShell Access Attempts
			modsecurity_crs_45_trojans.conf


Chapter 7  - Defending Authentication

		  Recipe 7-1: Detecting the Submission of Common/Default Usernames
			recipe-7-1.conf

		  Recipe 7-2: Detecting the Submission of Multiple Usernames
			recipe-7-2.conf

		  Recipe 7-3: Detecting Failed Authentication Attempts
			recipe-7-3.conf

		  Recipe 7-4: Detecting a High Rate of Authentication Attempts
			modsecurity_crs_11_brute_force.conf

		  Recipe 7-5: Normalizing Authentication Failure Details
			recipe-7-5.conf

		  Recipe 7-6: Enforce Password Complexity
			recipe-7-6.conf

		  Recipe 7-7: Correlating Usernames with SessionIDs
			modsecurity_crs_16_username_tracking.conf


Chapter 8  - Defending Session State

		  Recipe 8-1: Detecting Invalid Cookies
			modsecurity_crs_40_appsensor_detection_point_2.3_session_exception.conf

		  Recipe 8-2: Detecting Cookie Tampering
			modsecurity_crs_40_appsensor_detection_point_2.3_session_exception.conf

		  Recipe 8-3: Enforcing Session Timeouts
			modsecurity_crs_40_appsensor_detection_point_2.3_session_exception.conf

		  Recipe 8-4: Detecting Client Source Location Changes During Session Lifetime
			modsecurity_crs_40_appsensor_detection_point_2.3_session_exception.conf

		  Recipe 8-5: Detecting Browser Fingerprint Changes During Sessions
			modsecurity_crs_40_appsensor_detection_point_2.3_session_exception.conf
			fingerprint.js
			md5.js


Chapter 9  - Preventing Application Attacks

		  Recipe 9-1: Blocking Non-ASCII Characters
			modsecurity_crs_20_protocol_violations.conf

		  Recipe 9-2: Preventing Path-Traversal Attacks
			modsecurity_crs_20_protocol_violations.conf

		  Recipe 9-3: Preventing Forceful Browsing Attacks
			recipe-9-3.conf

		  Recipe 9-4: Preventing SQL Injection Attacks
			modsecurity_crs_41_sql_injection_attacks.conf

		  Recipe 9-5: Preventing Remote File Inclusion (RFI) Attacks
			modsecurity_crs_40_generic_attacks.conf

		  Recipe 9-6: Preventing OS Commanding Attacks
			modsecurity_crs_40_generic_attacks.conf

		  Recipe 9-7: Preventing HTTP Request Smuggling Attacks
			modsecurity_crs_40_generic_attacks.conf

		  Recipe 9-8: Preventing HTTP Response Splitting Attacks
			modsecurity_crs_40_generic_attacks.conf

		  Recipe 9-9: Preventing XML Attacks
			recipe-9-9.conf


Chapter 10 - Preventing Client Attacks

		  Recipe 10-1: Implementing Content Security Policy (CSP)
			modsecurity_crs_10_setup.conf			modsecurity_crs_42_csp_enforcement.conf

		  Recipe 10-2: Preventing Cross-Site Scripting (XSS) Attacks
			modsecurity_crs_41_xss_attacks.conf
			recipe-10-2.conf
			acs.js
			xss.js
			modsecurity_crs_55_application_defects.conf

		  Recipe 10-3: Preventing Cross-Site Request Forgery (CSRF) Attacks
			modsecurity_crs_43_csrf_attacks.conf
			recipe-10-3.conf

		  Recipe 10-4: Preventing UI Redressing (Clickjacking) Attacks
			recipe-10-4.conf
			frame-buster.js

		  Recipe 10-5: Detecting Banking Trojan (Man-in-the-Browser) Attacks
			recipe-10-5.conf
			md5.js
			webtripwire-login.js

Chapter 11 - Defending File Uploads

		  Recipe 11-1: Detecting Large File Sizes
			modsecurity_crs_23_request_limits.conf

		  Recipe 11-2: Detecting a Large Number of Files
			modsecurity_crs_23_request_limits.conf

		  Recipe 11-3: Inspecting File Attachments for Malware
			modsecurity_crs_46_av_scanning.conf
			runav.pl program

Chapter 12 - Enforcing Access Rate and Application Flows

		  Recipe 12-1: Detecting High Application Access Rates
			modsecurity_crs_10_setup.conf
			modsecurity_crs_11_dos_protection.conf

		  Recipe 12-2: Detecting Request/Response Delay Rates
			recipe-12-2.conf

		  Recipe 12-3: Identifying Inter-Request Time Delay Anomalies
			recipe-12-3.conf

		  Recipe 12-4: Identifying Request Flow Anomalies
			recipe-12-4.conf


Part III: Response Actions

Chapter 13 - Passive Response Actions

		  Recipe 13-1: Tracking Anomaly Scores
			modsecurity_crs_49_inbound_blocking.conf
			recipe-13-1.conf

		  Recipe 13-2: Trap and Trace Audit Logging
			recipe-13-2.conf

		  Recipe 13-3: Issuing E-mail Alerts
			recipe-13-3.conf
			alert_email.pl

		  Recipe 13-4: Data Sharing with Request Header Tagging
			modsecurity_crs_49_header_tagging.conf


Chapter 14 - Active Response Actions

		  Recipe 14-1: Using Redirection to Error Pages
			recipe-14-1.conf
             
		  Recipe 14-2: Dropping Connections
			recipe-14-2.conf

		  Recipe 14-3: Blocking the Client Source Address
			recipe-14-3.conf
			blacklist_client_local_fw.sh
			blacklist_client_remote_fw.sh

		  Recipe 14-4: Restricting Geolocation Access Through Defense Condition (DefCon) Level Changes
			recipe-14-4.conf
		
		  Recipe 14-5: Forcing Transaction Delays
			recipe-14-5.conf

		  Recipe 14-6: Spoofing Successful Attacks
			recipe-14-6.conf
			fake_sql_errors.html

		  Recipe 14-7: Proxy Traffic to Honeypots
			recipe-14-7.conf

		  Recipe 14-8: Forcing an Application Logout
			recipe-14-8.conf
			wordpress_logout.sh

		  Recipe 14-9: Temporarily Locking Account Access
			recipe-14-9.conf


Chapter 15 - Intrusive Response Actions

		  Recipe 15-1: JavaScript Cookie Testing
			recipe-15-1.conf

		  Recipe 15-2: Validating Users with CAPTCHA Testing
			recipe-15-2.conf

		  Recipe 15-3: Hooking Malicious Clients with BeEF
			recipe-15-3.conf

-----------------------------------------------------------------

Please use the Errata form for the book on www.wrox.com to send
comments, bug reports, etc.
-----------------------------------------------------------------