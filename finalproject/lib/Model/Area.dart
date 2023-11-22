class City{
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City({required this.isSelected, required this.city, required this.country, required this.isDefault});

  //List of Cities data
  static List<City> citiesList = [
    City(
        isSelected: false,
        city: 'Karachi',
        country: 'Pakistan',
        isDefault: true),
    City(
        isSelected: false,
        city: 'Lahore',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Islamabad',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Peshawar',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Quetta',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Multan',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Rawalpindi',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Sialkot',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bahawalpur',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Sheikhupura',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Gujrat',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Kasur',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Sargodha',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Gujranwala',
        country: 'Pakistan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Okara',
        country: 'Pakistan',
        isDefault: false),
  ];

  //Get the selected cities
  static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }
}