import 'package:gsheets/gsheets.dart';

const credentials = r'''
{
  "type": "service_account",
  "project_id": "flutter-sheets-437409",
  "private_key_id": "308510fd3ea9d0c8f7998652c4cc5c01ea81174d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDgl3hIGODXRaFd\nKZQa4Z3rYQtX8erXTod29yk2bPH3g5J/DxqXIZSsIUiH9aGVJl3Zrn3+5I8TgqNB\nH7PQw2uMrfFGQb1NHWixzjw9sdUQEwJNVVHHJXBHfAyIYr9ugCwU8xOf68kTS/pm\njMEnRMlQn50v/UEO6AmWdo9tee82Ag2bL4nPd9JdvcB1YttVdpdeJVmQGj4VPGSk\nJEkLKQUMX87NfSMQLTUFE1E7E3yj0LWcwIuVC14lLEbDFOBP6VDWMYBz01sqEdqh\n1Q2Ax46q0oOE3hujcC/Pwc+LK1yPM3O6yje+CvAu2cGoQ0JyP3CxnRJYI8NWNw+u\n3VdY2y2HAgMBAAECggEAO8AgeHHh83OrY+kpZWNry5DEX0/VjhVu1bgYx0mBsDtZ\nUKNYjCebcZXjQYSYSeFsq3qQO61b4TFqtGs2QA6VgNZP78SSk78EuPUosrMqf33H\nKYLO4F/1+JaokOpQipnf4Gzw5iVpF9CpW/oLcyKKOoBUZc2HLuuNjXGaY+JCQUgX\n59ZBy6ttelhHS6lXT59hYv3/eRmX85Xxs9IgOsTgHIGnkiUuEVOGcB0JCMyjTOi1\nxnOlboXfp9Q39+2U88QDkWvZlwke2CkbCAXxIKfKsSbHPuQpIyovrVCPXFmcNl0m\nS0lfFXxBf07S+OUPYVYXm1BkqNz8wFcm8bfunxc3uQKBgQD3X6cz+8RGLNe7F89u\nXU3wMBSotLLzfUIBpQNEd57rj2EsIz2U/sAE2qP3kW77VY2pQQDXe2Hj4M4tcshY\n6akhlh9z52cp+QjdNlJgESdwLVk46oy2jJikJFcuDkDSl7nzFopxii7k6AhF84V/\nokQT88PnjCIQ0z3BB1O+zx3ZfwKBgQDobHAuJ8ksTT1b3pVT1UjcALZKQMOyNO4h\nOLtPZp3BDH/Vp1KeBy8ZONbNYv6Lk1gDL8o/VWxlHvrecPeZQXxbTn9Yxn81P0cu\n1wodoAGQIKwcFedMH7aBKCKYUAY3Aohfrg4CWE/JtczNfEGoq+KI4Q6xfBnt7Xnk\n3/rD2CPf+QKBgQC3XF2RuLL52U9nTPTit6KHwPvvOVHUDiqZEXlkjM5tiO/cSZri\nEBrA/le/sDt1bSr+JEK9dqVOxlnNcmFzFm/Zh290+DeN8xxQ7G0O7GgxTEvwVltL\nDNgwAwfkCYifEPwyZajlFCpCXoOTZji0LNENgQjbXxH5KruBky7OJrPXfQKBgCCP\nWGPO5QrUwzzEgMzeuzc+zkq2qfOkIJv805i6+myZ8Kqgpx1GSl3RLZ5WOOyatqCz\nqDSZJfdAkMpqrvUETISKCaMJI7b052bzbxJZYP6s5Q+GLgHnC20qjzYhN82rCCnH\nO2Uus/bBBjDfMF+NvM2KIcHRbdx8ATCEBCA9fkEZAoGBAORXgBPmBL/zFVbHFIsD\nZqQGe+Fd301fZtJW2Je7ZHxStytFwd3SH564bnHrcE18qrdf+edchCWgpujArugU\nSw0n+2CavhVrXcJjCWlswgDzrqJNIMhG2Bi+ERCGgLXnB5oqn/K42VlwkeQHPBDk\nGEWPJp81ywwKvqG4/C+iFU90\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-sheets@flutter-sheets-437409.iam.gserviceaccount.com",
  "client_id": "107926352547901415634",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-sheets%40flutter-sheets-437409.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

// Class to encapsulate the spreadsheet service
class SalesSpreadsheetService {
  final String _spreadsheetId = "1hQbktLheYeAkNdsPTH7KxzWZ5TxhKErT0mBCYjH-7Sg"; // Replace with your actual Spreadsheet ID

  Future<GSheets> _initializeGsheets() async {
    final gsheets = GSheets(credentials);
    return gsheets;
  }

  // Function to create a new worksheet for a business ID if it does not exist
  Future<void> createSalesSheetIfNotExists(String businessId) async {
    final gsheets = await _initializeGsheets();
    final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);

    // Check if the worksheet already exists
    final existingSheet = spreadsheet.worksheetByTitle(businessId);
    
    if (existingSheet == null) {
      // Create a new worksheet with the business ID
      await spreadsheet.addWorksheet(businessId);
      print('Worksheet for business ID "$businessId" created successfully.');
    } else {
      print('Worksheet for business ID "$businessId" already exists.');
    }
  }

  // Function to fetch the sales data from the spreadsheet
Future<List<Map<String, dynamic>>> getSalesData(String sheetTitle) async {
  final gsheets = await _initializeGsheets();
  final spreadsheet = await gsheets.spreadsheet(_spreadsheetId);

  // Access the worksheet by its title
  final sheet = spreadsheet.worksheetByTitle(sheetTitle);

  if (sheet != null) {
    // Fetch all rows
    final rows = await sheet.values.allRows();

    // Convert rows into a list of maps, where each map represents a sale
    final List<Map<String, dynamic>> salesData = [];

    // The first row contains column headers
    final headers = rows[0];

    // Iterate over the rows, starting from the second row (index 1)
    for (int i = 1; i < rows.length; i++) {
      final Map<String, dynamic> sale = {};
      for (int j = 0; j < headers.length; j++) {
        // Assuming the first column is Order ID, and others follow
        sale[headers[j]] = rows[i][j];
      }
      salesData.add(sale);
    }

    return salesData;
  } else {
    throw Exception('Worksheet not found');
  }
}

  
}
