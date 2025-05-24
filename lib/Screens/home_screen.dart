import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import 'widgets/search_overlay.dart';
import 'widgets/category_card.dart';
import 'widgets/product_card.dart';
import 'widgets/offer_banner.dart';
import 'widgets/islamic_quote_section.dart';
import 'widgets/about_section.dart';
import 'widgets/feature_item.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showSearch = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/logo.png'),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        _showSearch = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                      // TODO: Navigate to cart
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Content Sections
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Section
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/main.jpg',
                          height: 500,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 100,
                          child: Column(
                            children: [
                              Text(
                                'Elegant Islamic Wear',
                                style: AppTextStyles.headline.copyWith(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Navigate to collection
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary.withOpacity(0.9),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Explore Collection',
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Categories Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                CategoryCard(
                                  title: 'Khimar',
                                  imageUrl: 'assets/images/khimar1.jpg',
                                ),
                                CategoryCard(
                                  title: 'Abaya',
                                  imageUrl: 'assets/images/abaya.jpg',
                                ),
                                CategoryCard(
                                  title: 'Borka',
                                  imageUrl: 'assets/images/borka.jpg',
                                ),
                                CategoryCard(
                                  title: 'Gown',
                                  imageUrl: 'assets/images/gown.jpg',
                                ),
                                CategoryCard(
                                  title: 'Cloak',
                                  imageUrl: 'assets/images/cloak.jpg',
                                ),
                                CategoryCard(
                                  title: 'Shirt',
                                  imageUrl: 'assets/images/shirt.jpg',
                                ),
                                CategoryCard(
                                  title: 'Kurti',
                                  imageUrl: 'assets/images/kurti.jpg',
                                ),
                                CategoryCard(
                                  title: 'Duster',
                                  imageUrl: 'assets/images/duster.jpg',
                                ),
                                // Add more categories...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // New Arrivals Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Arrivals',
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                ProductCard(
                                  imageUrl: 'assets/images/abaya2.jpg',
                                  title: 'Classic Black Abaya',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/khimar2.jpg',
                                  title: 'Classic Khimar',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/duster.jpg',
                                  title: 'Classic Duster',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/kurti.jpg',
                                  title: 'Classic Kurti',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/shirt.jpg',
                                  title: 'Classic Shirt',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/borka.jpg',
                                  title: 'Classic Borka',
                                  price: '\$129.99',
                                ),
                                // Add more products...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Offers Banner
                    const OfferBanner(
                      imageUrl: 'assets/images/onboarding1_main.jpg',
                      title: 'Eid Special Sale',
                      subtitle: 'Up to 40% Off',
                    ),

                    //best sellers
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Best Sellers',
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                ProductCard(
                                  imageUrl: 'assets/images/abaya.jpg',
                                  title: 'Classic Black Abaya',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/khimar1.jpg',
                                  title: 'Classic Khimar',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/duster.jpg',
                                  title: 'Classic Duster',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/kurti.jpg',
                                  title: 'Classic Kurti',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/shirt.jpg',
                                  title: 'Classic Shirt',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/borka.jpg',
                                  title: 'Classic Borka',
                                  price: '\$129.99',
                                ),
                                // Add more products...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Islamic Quote Section
                    const IslamicQuoteSection(),

                    //Just for user
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Just For You',
                            style: AppTextStyles.headline.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: const [
                                ProductCard(
                                  imageUrl: 'assets/images/abaya2.jpg',
                                  title: 'Classic Black Abaya',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/khimar2.jpg',
                                  title: 'Classic Khimar',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/duster.jpg',
                                  title: 'Classic Duster',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/kurti.jpg',
                                  title: 'Classic Kurti',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/shirt.jpg',
                                  title: 'Classic Shirt',
                                  price: '\$129.99',
                                ),
                                ProductCard(
                                  imageUrl: 'assets/images/borka.jpg',
                                  title: 'Classic Borka',
                                  price: '\$129.99',
                                ),
                                // Add more products...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // About Section
                    const AboutSection(),

                    // Features Section
                    const FeaturesGrid(),

                    // Footer
                    const Footer(),
                  ],
                ),
              ),
            ],
          ),

          // Search Overlay
          if (_showSearch)
            SearchOverlay(
              onClose: () {
                setState(() {
                  _showSearch = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}