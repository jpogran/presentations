# title slide

Using Puppet and DSC to Report on Environment Change

# contact info slide

James Pogran
Senior Software Engineer | Puppet
james.pogran@puppet.com
@ender2025
jamespogran.com

# bio slide

15 years in the industry
8 of those writing windows automation
2 of those deploying apps to production using DSC
wrote a book called Learning PowerShell DSC

# agenda

Current state of DSC


# Positioning Statement

Knowledge of change on critical infrastructure is key to maintaing uptime

This talk will setup an environment using Puppet and DSC and show how the Puppet console will track and report on change that has occured in your environment, both from your configuration management files and from outside users. Then it will show how Puppet ensures the proper state is kept on your servers.

# CHALLENGE

You want to get the most out of your investment in time and effort by tracking change in your environment

DSC by itself offers little historical information on what changes were done in your environment

ever wanted to have a window sitting on your desktop that showed you consistency checks for a given node? want to be able to configure a server by typing a name, telling it what config to use? then hit go and have it just work? tired of trying to get nodes registerting with dsc pull server? want it to just work?

# EFFECT

Lost time investigating manually why something did or did not change

No one portal or api to use

Have to search through many different logs using different tools

# NEED

You need a single way to view logs and diagnostic information across all of your nodes without manual effort

The information must be collated for you without have to do extra configuration

# SOLUTION

PE presents the logs and diagnostic information from each node in a central, queryable, databse for reporting

You already have Puppet and PowerShell DSC working together on your systems at your company. Puppet made it easy to plug in DSC to handle special circumstances while Puppet handled the rest of the configuration management on your servers, no matter the platform.

# demo of finding out how a change happened

# BENEFITS

* Single pane of glass
* Reports for most cases
* Queryable provides customized reporting

* DSC logs in a central place
* No scripts or queries to find logs after fact

# DIFFERENTIATION

Puppet presents logs in an easy to consume format that isoltes issues and elevates solutions

# VALIDATE

# SUMMARIZE
