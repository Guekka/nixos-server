{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "trucmuche909@gmail.com";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persist".directories = ["/var/lib/acme"];
  };
}
