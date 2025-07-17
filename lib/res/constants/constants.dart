const String domain = 'investtracks.com';
const String website = 'https://$domain';
const String baseUrl = 'https://investtracks.com/';
const String apiBaseUrl = '${baseUrl}api/';
const String supportEmail = 'support@$domain';
const String companyDomain = 'turskyi.com';
const String appName = 'InvestTrack';
const String authServiceLink = 'https://clerk.com';
const String authServiceName = 'Clerk';
const String remoteDbServiceName = 'Vercel Postgres';
const String remoteDbServiceLink =
    'https://vercel.com/docs/storage/vercel-postgres#vercel-postgres';
const String deletionInstructionsLink = '${baseUrl}instruction';
const int emailMaxLength = 40;
const int emailMinLength = 9;
const int maxRetries = 1;
const int retryDelayInMs = 1000;
const int itemsPerPage = 6;
// Represents the offset to determine the next page.
const int pageOffset = 1;
const String imagePath = 'assets/images/';

/// Blur intensity constant.
const double blurSigma = 3.0;
