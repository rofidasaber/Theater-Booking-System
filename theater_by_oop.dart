import 'dart:io';

void main() {
  // Create a new theater booking system and start it
  TheaterBookingSystem bookingSystem = TheaterBookingSystem();
  bookingSystem.start();
}

/// Class representing a seat in the theater
class Seat {
  final int row;
  final int column;
  bool isBooked;

  Seat(this.row, this.column, {this.isBooked = false});

  String getDisplayStatus() {
    return isBooked ? 'B' : 'E';
  }

  String getPosition() {
    // Return position in 1-indexed format (for user interaction)
    return "${row + 1},${column + 1}";
  }
}

/// Class representing a user booking
class Booking {
  final String name;
  final String phoneNumber;
  final Seat seat;

  Booking(this.name, this.phoneNumber, this.seat);
}

/// Class to manage the theater system
class TheaterBookingSystem {
  static const int ROWS = 5;
  static const int COLUMNS = 5;
  
  late List<List<Seat>> seatLayout;
  final Map<String, Booking> bookings = {};

  TheaterBookingSystem() {
    // Initialize the theater seats
    initializeSeats();
  }

  void initializeSeats() {
    seatLayout = List.generate(
      ROWS,
      (row) => List.generate(
        COLUMNS,
        (col) => Seat(row, col)
      )
    );
  }

  void start() {
    print("Welcome To Our Theater");

    while (true) {
      displayMenu();
      String? input = getUserInput("Input=> ");

      switch (input) {
        case '1':
          bookSeat();
          break;
        case '2':
          displayTheaterSeats();
          break;
        case '3':
          displayBookingDetails();
          break;
        case '4':
          print("Thank you for using our theater booking system. Goodbye!");
          return;
        default:
          print("Invalid option. Please try again.");
      }
    }
  }

  void displayMenu() {
    print("\nPress 1 to book a new seat");
    print("Press 2 to show the theater seats");
    print("Press 3 to show users' data");
    print("Press 4 to exit");
  }

  String? getUserInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync();
  }

  void bookSeat() {
    // Get row input
    String? rowInput = getUserInput("Enter row (1-5) or 'exit' to quit: ");
    if (rowInput?.toLowerCase() == 'exit') return;

    int row = int.tryParse(rowInput ?? '') ?? -1;
    if (!isValidRowOrColumn(row)) {
      print("Invalid row number. Please enter a number between 1 and 5.");
      return;
    }

    // Get column input
    String? colInput = getUserInput("Enter column (1-5): ");
    int col = int.tryParse(colInput ?? '') ?? -1;
    if (!isValidRowOrColumn(col)) {
      print("Invalid column number. Please enter a number between 1 and 5.");
      return;
    }

    // Convert to zero-based index
    int rowIndex = row - 1;
    int colIndex = col - 1;

    // Check if seat is available
    Seat selectedSeat = seatLayout[rowIndex][colIndex];
    if (selectedSeat.isBooked) {
      print("This seat is already booked. Please choose another seat.");
      return;
    }

    // Get user details
    String? name = getUserInput("Enter your name: ");
    String? phone = getUserInput("Enter your phone number: ");

    if (name == null || phone == null || name.isEmpty || phone.isEmpty) {
      print("Name and phone number are required. Please try again.");
      return;
    }

    // Book the seat
    selectedSeat.isBooked = true;
    Booking newBooking = Booking(name, phone, selectedSeat);
    bookings[selectedSeat.getPosition()] = newBooking;

    print("Seat booked successfully!");
  }

  bool isValidRowOrColumn(int value) {
    return value >= 1 && value <= 5;
  }

  void displayTheaterSeats() {
    print("\nTheater Seats:");
    for (var row in seatLayout) {
      String rowDisplay = row.map((seat) => seat.getDisplayStatus()).join(' ');
      print(rowDisplay);
    }
  }

  void displayBookingDetails() {
    print("\nUsers Booking Details:");
    if (bookings.isEmpty) {
      print("No bookings yet.");
    } else {
      bookings.forEach((seatPosition, booking) {
        print("Seat $seatPosition: ${booking.name} - ${booking.phoneNumber}");
      });
    }
  }
}