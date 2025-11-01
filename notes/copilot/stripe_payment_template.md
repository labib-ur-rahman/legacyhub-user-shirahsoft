# 🚀 Stripe Payment Template

A professional, easy-to-use Stripe payment integration template for Flutter applications. Just pass a Stripe URL and optional access token to get started with secure payments.

## 🌟 Features

- ✅ **Easy Integration**: Just pass your Stripe URL and start accepting payments
- ✅ **Multi-Language Support**: Built-in English and Bengali translations
- ✅ **Professional UI**: Modern, responsive design with custom theming
- ✅ **Automatic Detection**: Smart payment completion detection
- ✅ **Error Handling**: Comprehensive error handling and user feedback
- ✅ **Callback Support**: Success, failure, and cancellation callbacks
- ✅ **Custom Styling**: Professional Stripe form styling
- ✅ **Authentication**: Optional access token support
- ✅ **Logging**: Built-in logging for debugging

## 🚀 Quick Start

### Basic Usage

The simplest way to integrate Stripe payments:

```dart
import 'package:project_template/features/stripe/controllers/stripe_payment_template_controller.dart';

// Launch payment with minimal configuration
StripePaymentTemplate.launchPayment(
  stripeUrl: 'https://checkout.stripe.com/c/pay/cs_test_...',
);
```

### Advanced Usage with Callbacks

```dart
StripePaymentTemplate.launchPayment(
  stripeUrl: 'https://checkout.stripe.com/c/pay/cs_test_...',
  accessToken: 'your_access_token', // Optional
  onSuccess: () {
    print('Payment successful!');
    // Navigate to success page, update user status, etc.
  },
  onFailure: (error) {
    print('Payment failed: $error');
    // Handle payment failure
  },
  onCancel: () {
    print('Payment cancelled');
    // Handle user cancellation
  },
  additionalHeaders: {
    'Custom-Header': 'value',
  },
  enableCustomStyling: true,
  enableLogging: true,
);
```

## 🎯 Integration Examples

### 1. Subscription Payment

```dart
void handleSubscriptionPayment(String planId) {
  StripePaymentTemplate.launchPayment(
    stripeUrl: 'https://checkout.stripe.com/c/pay/cs_test_subscription_url',
    accessToken: await getAuthToken(),
    onSuccess: () {
      // Update user subscription status
      updateUserSubscription(planId);
      Get.offAllNamed(AppRoutes.dashboard);
    },
    onFailure: (error) {
      EasyLoading.showError('Subscription payment failed: $error');
    },
    onCancel: () {
      EasyLoading.showInfo('Subscription cancelled');
    },
  );
}
```

### 2. One-time Purchase

```dart
void handleProductPurchase(String productId, double amount) {
  StripePaymentTemplate.launchPayment(
    stripeUrl: 'https://checkout.stripe.com/c/pay/cs_test_product_url',
    onSuccess: () {
      // Process successful purchase
      processPurchase(productId, amount);
      Get.snackbar('Success', 'Purchase completed successfully!');
    },
    onFailure: (error) {
      Get.snackbar('Error', 'Purchase failed: $error');
    },
  );
}
```

### 3. Custom Controller Integration

```dart
class PaymentController extends GetxController {
  
  void initiatePayment(String stripeUrl) {
    final paymentController = StripePaymentTemplateController(
      stripeUrl: stripeUrl,
      accessToken: await getAccessToken(),
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onCancel: _handlePaymentCancel,
    );
    
    // Register controller
    Get.put(paymentController);
    
    // Navigate to payment screen
    Get.to(() => const StripePaymentScreen());
  }
  
  void _handlePaymentSuccess() {
    // Your success logic here
    updatePaymentStatus('completed');
  }
  
  void _handlePaymentFailure(String error) {
    // Your failure logic here
    logPaymentError(error);
  }
  
  void _handlePaymentCancel() {
    // Your cancellation logic here
    updatePaymentStatus('cancelled');
  }
}
```

## 🎨 UI Components

### Payment Screens

The template includes three professional UI screens:

1. **`StripePaymentScreen`** - Main payment WebView screen
2. **`PaymentSuccessScreen`** - Success confirmation with features list
3. **`PaymentFailureScreen`** - Error handling with retry options

### Customizable Elements

- Colors and theming via `AppColors`
- Text content via `AppStrings` (multi-language)
- Loading states and animations
- Error messages and user feedback

## 🌍 Multi-Language Support

The template supports multiple languages out of the box:

### English (Default)
```dart
'payment_successful': 'Payment Successful',
'payment_failed': 'Payment Failed',
'secure_payment': 'Secure Payment',
// ... more strings
```

### Bengali
```dart
'payment_successful': 'পেমেন্ট সফল',
'payment_failed': 'পেমেন্ট ব্যর্থ',
'secure_payment': 'নিরাপদ পেমেন্ট',
// ... more strings
```

### Adding New Languages

1. Create a new language file in `lib/core/localization/languages/`
2. Add translations for all payment-related keys
3. Update `languages.dart` to include the new locale

## 🔧 Configuration Options

### StripePaymentTemplateController Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `stripeUrl` | `String` | ✅ | Your Stripe checkout URL |
| `accessToken` | `String?` | ❌ | Optional authentication token |
| `onSuccess` | `VoidCallback?` | ❌ | Success callback function |
| `onFailure` | `Function(String)?` | ❌ | Failure callback with error message |
| `onCancel` | `VoidCallback?` | ❌ | Cancellation callback function |
| `additionalHeaders` | `Map<String, String>?` | ❌ | Custom HTTP headers |
| `enableCustomStyling` | `bool` | ❌ | Enable/disable custom CSS styling (default: true) |
| `enableLogging` | `bool` | ❌ | Enable/disable logging (default: true) |

### Supported Stripe URLs

The template validates and supports these Stripe domains:
- `checkout.stripe.com`
- `js.stripe.com`
- `pay.stripe.com`
- `connect.stripe.com`

## 🎯 Payment Flow Detection

The template automatically detects payment completion based on URL patterns:

### Success Patterns
- `success`
- `payment_intent`
- `setup_intent`
- `payment_status=succeeded`
- `return_url`

### Failure Patterns
- `cancel`, `cancelled`
- `payment_status=failed`
- `error`

### Custom Detection

You can extend the detection logic by modifying the `_isPaymentCompleteUrl` method in the controller.

## 🎨 Custom Styling

The template applies professional CSS styling to Stripe forms:

### Features
- Modern input field styling
- Responsive design for mobile/desktop
- Custom button gradients
- Error state styling
- Loading animations
- Brand color integration

### Customization

To modify the styling, edit the `_injectCustomStyling` method in the template controller.

## 🐛 Debugging & Logging

### Enable Logging
```dart
StripePaymentTemplate.launchPayment(
  stripeUrl: 'your_url',
  enableLogging: true, // Enable detailed logs
);
```

### Log Messages
- `🚀` Initialization
- `📱` URL validation
- `🔄` Loading states
- `✅` Success events
- `❌` Error events
- `🎯` Payment detection
- `🎨` Styling injection

## 📱 Testing

### Use Test URL
```dart
// Get pre-configured test URL
final testUrl = StripePaymentTemplate.getTestUrl();

StripePaymentTemplate.launchPayment(
  stripeUrl: testUrl,
  enableLogging: true,
);
```

### Test Scenarios
1. **Successful Payment**: Complete payment flow
2. **Payment Failure**: Test error handling
3. **User Cancellation**: Test cancellation flow
4. **Network Issues**: Test offline scenarios
5. **Invalid URLs**: Test validation

## 🚀 Demo Screen

Use the included demo screen to test the template:

```dart
import 'package:project_template/features/stripe/views/screens/stripe_payment_example_screen.dart';

// Navigate to demo screen
Get.to(() => const StripePaymentExampleScreen());
```

## 🔄 Migration from Old Implementation

If you're migrating from the old `StripePaymentController`:

### Before (Old)
```dart
final controller = Get.put(StripePaymentController());
Get.to(() => StripePaymentScreen());
```

### After (New Template)
```dart
StripePaymentTemplate.launchPayment(
  stripeUrl: 'your_stripe_url',
  onSuccess: () => print('Success!'),
);
```

## 📋 Checklist for Integration

- [ ] Replace hardcoded Stripe URLs with your actual URLs
- [ ] Add your access token handling logic
- [ ] Implement success/failure callbacks
- [ ] Test payment flow end-to-end
- [ ] Verify multi-language support
- [ ] Test on both iOS and Android
- [ ] Validate error handling scenarios
- [ ] Configure custom styling if needed

## 🎯 Best Practices

1. **Always validate URLs** before passing to the template
2. **Handle all callbacks** for better user experience
3. **Enable logging** during development
4. **Test thoroughly** with real Stripe test URLs
5. **Implement proper error recovery** mechanisms
6. **Use secure token handling** for access tokens

## 🆘 Troubleshooting

### Common Issues

**Issue**: WebView not loading
**Solution**: Check URL validity and internet connection

**Issue**: Payment not detected
**Solution**: Verify Stripe URL contains proper completion parameters

**Issue**: Styling not applied
**Solution**: Ensure `enableCustomStyling: true` and check console logs

**Issue**: Callbacks not called
**Solution**: Verify URL patterns match the detection logic

### Support

For issues and feature requests, check the template controller code or create an issue in your project repository.

## 🏆 Conclusion

This Stripe Payment Template provides a professional, production-ready solution for integrating Stripe payments in Flutter applications. With minimal setup and maximum flexibility, you can start accepting payments immediately while maintaining a great user experience across multiple languages and platforms.

Happy coding! 🚀