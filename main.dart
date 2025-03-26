import 'dart:io';

void main() {
  // Initialize a 5x5 theater seating layout with all seats empty ('E')
  List<List<String>> theaterSeats = List.generate(5, (_) => List.filled(5, 'E'));

  // A map to store booking details (seat_position -> user data)
  Map<String, Map<String, String>> bookings = {};

  print("Welcome To Our Theater");

  while (true) {
    // Display menu options
    print("\nPress 1 to book a new seat");
    print("Press 2 to show the theater seats");
    print("Press 3 to show users' data");
    print("Press 4 to exit");

    // Get user input for menu choice
    stdout.write("Input=> ");
    String? input = stdin.readLineSync();

    if (input == '1') {
      // Book a new seat
      stdout.write("Enter row (1-5) or 'exit' to quit: ");
      String? rowInput = stdin.readLineSync();
      if (rowInput?.toLowerCase() == 'exit') continue;

      int row = int.tryParse(rowInput ?? '') ?? -1;
      if (row < 1 || row > 5) {
        print("Invalid row number. Please enter a number between 1 and 5.");
        continue;
      }

      stdout.write("Enter column (1-5): ");
      String? colInput = stdin.readLineSync();
      int col = int.tryParse(colInput ?? '') ?? -1;
      if (col < 1 || col > 5) {
        print("Invalid column number. Please enter a number between 1 and 5.");
        continue;
      }

      // Convert to zero-based index
      int rowIndex = row - 1;
      int colIndex = col - 1;

      // Check if the seat is available
      if (theaterSeats[rowIndex][colIndex] == 'B') {
        print("This seat is already booked. Please choose another seat.");
        continue;
      }

      // Get user details
      stdout.write("Enter your name: ");
      String? name = stdin.readLineSync();
      stdout.write("Enter your phone number: ");
      String? phone = stdin.readLineSync();

      if (name == null || phone == null || name.isEmpty || phone.isEmpty) {
        print("Name and phone number are required. Please try again.");
        continue;
      }

      // Book the seat
      theaterSeats[rowIndex][colIndex] = 'B';
      String seatPosition = "$row,$col";
      bookings[seatPosition] = {'name': name, 'phone': phone};

      print("Seat booked successfully!");
    } else if (input == '2') {
      // Show theater seats
      print("\nTheater Seats:");
      for (var row in theaterSeats) {
        print(row.join(' '));
      }
    } else if (input == '3') {
      // Show users' booking details
      print("\nUsers Booking Details:");
      if (bookings.isEmpty) {
        print("No bookings yet.");
      } else {
        bookings.forEach((seat, userData) {
          print("Seat $seat: ${userData['name']} - ${userData['phone']}");
        });
      }
    } else if (input == '4') {
      // Exit the program
      print("Thank you for using our theater booking system. Goodbye!");
      break;
    } else {
      // Invalid input
      print("Invalid option. Please try again.");
    }
  }
}