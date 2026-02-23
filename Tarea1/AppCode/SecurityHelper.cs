using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace Tarea1.AppCode
{
    public class SecurityHelper
    {
        public static string HashPassword(string plain)
        {
            if (plain == null) plain = "";
            using (var sha = SHA256.Create())
            {
                var bytes = Encoding.UTF8.GetBytes(plain);
                var hash = sha.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }

        public static bool IsValidUrl(string url)
        {
            if (string.IsNullOrWhiteSpace(url))
                return false;

            Uri uri;
            return Uri.TryCreate(url, UriKind.Absolute, out uri)
                   && (uri.Scheme == Uri.UriSchemeHttp || uri.Scheme == Uri.UriSchemeHttps);
        }

        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) return false;
            email = email.Trim();

            
            var pattern = @"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$";
            return Regex.IsMatch(email, pattern, RegexOptions.IgnoreCase);
        }
    }
}