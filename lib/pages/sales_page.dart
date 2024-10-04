import 'package:buisness/services/sales_services.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  final Map<String, dynamic> business; 
  const SalesPage({super.key, required this.business});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _salesData = [];
  final SalesSpreadsheetService _salesSpreadsheetService = SalesSpreadsheetService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    try {
      // Fetch sales data using business ID
      _salesData = await _salesSpreadsheetService.getSalesData(widget.business['_id']);
      setState(() {}); // Update the UI
    } catch (e) {
      print('Error fetching sales data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Sales")),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Sales Table"),
            Tab(text: "Sales Graph"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSalesTable(),
          _buildSalesGraph(),
        ],
      ),
    );
  }

  Widget _buildSalesTable() {
    if (_salesData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _buildTableColumns(),
          rows: _salesData.map((sale) {
            return DataRow(cells: _buildTableCells(sale));
          }).toList(),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return const [
      DataColumn(label: Text('Order ID')),
      DataColumn(label: Text('Customer Name')),
      DataColumn(label: Text('Product Name')),
      DataColumn(label: Text('Quantity')),
      DataColumn(label: Text('Price per Unit')),
      DataColumn(label: Text('Total Price')),
      DataColumn(label: Text('Order Date')),
      DataColumn(label: Text('Status')),
    ];
  }

  List<DataCell> _buildTableCells(Map<String, dynamic> sale) {
    return [
      DataCell(Text(sale['Order ID']?.toString() ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Customer Name'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Product Name'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Quantity']?.toString() ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Price per Unit'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Total Price'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Order Date'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
      DataCell(Text(sale['Status'] ?? '', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary))),
    ];
  }

  Widget _buildSalesGraph() {
  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sales by Product (Bar Chart)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            SizedBox(
              height: 300,
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sales Distribution (Pie Chart)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            SizedBox(
              height: 300,
              child: _buildPieChart(),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildBarChart() {
  final productNames = _salesData.map((sale) => sale['Product Name']).toSet().toList();
  final totalSales = productNames.map((product) {
    double total = 0.0;
    for (var sale in _salesData) {
      if (sale['Product Name'] == product) {
        total += double.parse(sale['Total Price'].replaceAll('\$', '')); 
      }
    }
    return total;
  }).toList();

  return BarChart(
    BarChartData(
      barGroups: productNames.asMap().entries.map((entry) {
        int index = entry.key;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: totalSales[index],
              color: Theme.of(context).colorScheme.secondary, // Use theme color
            ),
          ],
        );
      }).toList(),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50, // Increase the reserved size to avoid truncation
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Transform.rotate(
                  angle: -45 * 3.1416 / 180, // Rotate labels by 45 degrees
                  child: Text(
                    productNames[value.toInt()],
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
    ),
  );
}


  Widget _buildPieChart() {
  final totalSalesByProduct = <String, double>{};

  for (var sale in _salesData) {
    String product = sale['Product Name'];
    double total = double.parse(sale['Total Price'].replaceAll('\$', ''));
    totalSalesByProduct[product] = (totalSalesByProduct[product] ?? 0) + total;
  }

  return PieChart(
    PieChartData(
      sections: totalSalesByProduct.entries.map((entry) {
        int index = totalSalesByProduct.keys.toList().indexOf(entry.key);
        return PieChartSectionData(
          color: index.isEven 
              ? Theme.of(context).colorScheme.secondary 
              : Theme.of(context).colorScheme.primary, // Alternate colors based on index
          value: entry.value,
          title: '${entry.key}\n${entry.value.toStringAsFixed(2)}',
          titleStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.inversePrimary), 
          radius: 90, // Increased radius for thicker slices (adjust value as needed)
        );
      }).toList(),
      borderData: FlBorderData(show: false),
    ),
  );
}

}
