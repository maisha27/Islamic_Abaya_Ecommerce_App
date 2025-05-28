import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/widgets/custom_app_silver_bar.dart';
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
import '../controllers/product_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());
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
               const CustomSliverAppBar(
                floating: true,
                pinned: false,
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
                            child: Obx(() {
                              if (productController.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (productController.newArrivals.isEmpty) {
                                return const Center(child: Text('No new arrivals available'));
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productController.newArrivals.length,
                                itemBuilder: (context, index) {
                                  final product = productController.newArrivals[index];
                                  return ProductCard(
                                    imageUrl: product.imageUrl,
                                    title: product.title,
                                    price: '\$${product.price.toStringAsFixed(2)}',
                                    isWishlisted: product.isWishlisted,
                                    product: product,  // Add this
                                    onWishlistTap: () => productController.toggleWishlist(product.id),
                                  );
                                },
                              );
                            }),
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


                     // Islamic Quote Section
                    const IslamicQuoteSection(),

                    
                    // Best Sellers Section
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
                            child: Obx(() {
                              if (productController.isLoading.value) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (productController.bestSellers.isEmpty) {
                                return const Center(child: Text('No best sellers available'));
                              }

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productController.bestSellers.length,
                                itemBuilder: (context, index) {
                                  final product = productController.bestSellers[index];
                                  return ProductCard(
                                    imageUrl: product.imageUrl,
                                    title: product.title,
                                    price: '\$${product.price.toStringAsFixed(2)}',
                                    isWishlisted: product.isWishlisted,
                                    product: product,  // Add this
                                    onWishlistTap: () => productController.toggleWishlist(product.id),
                                  );
                                },
                              );
                            }),
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






