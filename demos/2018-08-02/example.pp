class web (
  String $site_path     = 'E:\\Dev\\Website\\',
  String $website_name  = 'new_website',
  String $app_pool_name = 'new_website_pool',
){
  windowsfeature{['Web-Server''Web-Asp-Net45']:
    ensure => present
  }

  iis_application_pool { $app_pool_name:
    ensure                  => 'present',
    state                   => 'started'
    managed_pipeline_mode   => 'Integrated',
    managed_runtime_version => 'v4.0',
  }
  -> iis_site { $website_name:
    ensure          => 'started',
    physicalpath    => $site_path,
    applicationpool => $app_pool_name,
  }

  file { $site_path:
    ensure => 'directory'
  }

}
