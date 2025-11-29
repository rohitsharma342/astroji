import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/data_service.dart';
import '../widgets/astrologer_card.dart';
import '../widgets/booking_summary.dart';
import 'astrologer_profile_screen.dart';
import 'chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  
  final List<String> categories = ['All', 'Vedic', 'Tarot', 'Numerology', 'Palmistry', 'Gemstones'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Astroji', style: AppTextStyles.heading1),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildDashboard() : _buildChatList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(dataService),
              SizedBox(height: 20),
              _buildCategoryTabs(dataService),
              SizedBox(height: 20),
              BookingSummary(),
              SizedBox(height: 20),
              _buildTrendingSection(dataService),
              SizedBox(height: 20),
              _buildAllAstrologers(dataService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(DataService dataService) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search astrologers...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onChanged: (value) => dataService.updateSearchQuery(value),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () => _showFilterModal(dataService),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs(DataService dataService) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = dataService.selectedCategory == category;
          return Container(
            margin: EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => dataService.updateSelectedCategory(category),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryColor : AppColors.dividerColor,
                  ),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.bodyText.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection(DataService dataService) {
    final trendingAstrologers = dataService.astrologers.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trending Astrologers', style: AppTextStyles.heading2),
        SizedBox(height: 15),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingAstrologers.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: EdgeInsets.only(right: 15),
                child: AstrologerCard(
                  astrologer: trendingAstrologers[index],
                  isHorizontal: true,
                  onTap: () => _navigateToProfile(trendingAstrologers[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllAstrologers(DataService dataService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('All Astrologers', style: AppTextStyles.heading2),
        SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: dataService.astrologers.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 15),
              child: AstrologerCard(
                astrologer: dataService.astrologers[index],
                onTap: () => _navigateToProfile(dataService.astrologers[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150'),
          ),
          title: Text('Dr. Priya Sharma'),
          subtitle: Text('Hello! I\'d be happy to help you...'),
          trailing: Text('2:30 PM', style: AppTextStyles.captionText),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                astrologerId: '1',
                astrologerName: 'Dr. Priya Sharma',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(astrologer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AstrologerProfileScreen(astrologer: astrologer),
      ),
    );
  }

  void _showFilterModal(DataService dataService) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Options', style: AppTextStyles.heading2),
              SizedBox(height: 20),
              Text('Price Range'),
              SizedBox(height: 10),
              RangeSlider(
                values: RangeValues(0, 50),
                min: 0,
                max: 100,
                divisions: 10,
                labels: RangeLabels('₹0', '₹50'),
                onChanged: (values) {},
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Apply Filters', style: AppTextStyles.buttonText),
              ),
            ],
          ),
        );
      },
    );
  }
}