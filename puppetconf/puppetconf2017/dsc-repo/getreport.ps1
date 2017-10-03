function GetReport {
  param(
    $AgentId = "$((glcm).AgentId)",
    $serviceURL = "https://PULLSERVER:8080/PSDSCPullServer.svc"
  )
  
  Add-Type @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            ServicePointManager.ServerCertificateValidationCallback += 
                delegate
                (
                    Object obj, 
                    X509Certificate certificate, 
                    X509Chain chain, 
                    SslPolicyErrors errors
                )
                {
                    return true;
                };
        }
    }
"@
 
  [ServerCertificateValidationCallback]::Ignore();

  $params = @{
    Uri             = "$serviceURL/Nodes(AgentId= '$AgentId')/Reports"
    ContentType     = "application/json;odata=minimalmetadata;streaming=true;charset=utf-8"
    UseBasicParsing = $true
    Headers         = @{
      Accept          = "application/json"
      ProtocolVersion = "2.0"
    }
  }

  $request = Invoke-WebRequest @params
  $object = ConvertFrom-Json $request.content
  return $object.value
}
GetReport
