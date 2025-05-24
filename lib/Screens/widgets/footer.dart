import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_constants.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      color: AppColors.primary,
      child: Column(
        children: [
          // Logo and Social Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'HayaLumière',
                    style: AppTextStyles.headline.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              // Social Links
              Row(
                children: [
                  _SocialButton(
                    icon: FontAwesomeIcons.facebookF,
                    onTap: () => _launchUrl('https://facebook.com/hayalumiere'),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  _SocialButton(
                    icon: FontAwesomeIcons.instagram,
                    onTap: () => _launchUrl('https://instagram.com/hayalumiere'),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  _SocialButton(
                    icon: FontAwesomeIcons.tiktok,
                    onTap: () => _launchUrl('https://tiktok.com/@hayalumiere'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingXL),

          // Quick Links and Contact Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterHeading('Quick Links'),
                    const SizedBox(height: AppDimensions.paddingM),
                    _FooterLink('About Us', onTap: () {}),
                    _FooterLink('Our Products', onTap: () {}),
                    _FooterLink('Size Guide', onTap: () {}),
                    _FooterLink('FAQs', onTap: () {}),
                  ],
                ),
              ),

              // Policies
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterHeading('Policies'),
                    const SizedBox(height: AppDimensions.paddingM),
                    _FooterLink('Privacy Policy', onTap: () {}),
                    _FooterLink('Return Policy', onTap: () {}),
                    _FooterLink('Shipping Policy', onTap: () {}),
                    _FooterLink('Terms of Service', onTap: () {}),
                  ],
                ),
              ),

              // Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterHeading('Contact Us'),
                    const SizedBox(height: AppDimensions.paddingM),
                    _ContactInfo(
                      icon: Icons.email_outlined,
                      text: 'support@hayalumiere.com',
                    ),
                    _ContactInfo(
                      icon: Icons.phone_outlined,
                      text: '+1 (555) 123-4567',
                    ),
                    _ContactInfo(
                      icon: Icons.location_on_outlined,
                      text: '123 Modest Fashion St\nNew York, NY 10001',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingXL),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Copyright and Last Updated
          Wrap(  // Changed from Row to Wrap
            alignment: WrapAlignment.spaceBetween,
            spacing: AppDimensions.paddingM,  // Horizontal spacing between items
            runSpacing: AppDimensions.paddingS,  // Vertical spacing when wrapped
            children: [
              Text(
                '© ${DateTime.now().year} HayaLumière. All rights reserved.',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Text(
                'Last updated: 2025-05-24 18:36:55',  // Updated timestamp
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

   @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: FaIcon(  // Changed from Icon to FaIcon
          icon,
          color: Colors.white,
          size: 20,  // Slightly smaller size for social icons
        ),
      ),
    );
  }
}

class _FooterHeading extends StatelessWidget {
  final String text;

  const _FooterHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.buttonText.copyWith(
        color: Colors.white,
        fontSize: 18,
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink(this.text, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: AppTextStyles.body.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.accent,
            size: AppDimensions.iconSizeM,
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}