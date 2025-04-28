import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upi_pay/core/provider/erupee_provider.dart';
import 'package:upi_pay/features/user/erupee-transaction/presentation/widgets/e_rupee_note.dart';
import 'package:upi_pay/features/user/payment/presentation/screens/payment_screen.dart';

class NoteCarouselScreen extends ConsumerStatefulWidget {
  const NoteCarouselScreen({super.key});
  @override
  _NoteCarouselScreenState createState() => _NoteCarouselScreenState();
}

class _NoteCarouselScreenState extends ConsumerState<NoteCarouselScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  final List<int> _denominations = [2, 5, 10, 20, 50, 100, 200, 500, 2000];
  int _currentPage = 0;
  double _totalLoaded = 0;

  // These drive the vertical offset animation
  late AnimationController _animController;
  late Animation<double> _anim;
  double _dragOffset = 0;
  bool _isAnimating = false;
  final _animCompleter = Completer<void>();
  bool _hasCompletedFirstAnimation = false;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });

    _animController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          )
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              if (!_hasCompletedFirstAnimation && _isAnimating) {
                _hasCompletedFirstAnimation = true;
                // Update the total after first animation completes
                setState(() {
                  if (_anim.value < 0) {
                    _totalLoaded += _denominations[_currentPage];
                  } else if (_anim.value > 0) {
                    _totalLoaded = max(
                      0,
                      _totalLoaded - _denominations[_currentPage],
                    );
                  }
                });

                // Setup return animation
                _setupReturnAnimation();
              } else if (_hasCompletedFirstAnimation && _isAnimating) {
                // Second animation completed
                _resetAnimationState();
              }
            }
          })
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          });

    // Initialize animation
    _anim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  void _setupReturnAnimation() {
    _anim = Tween<double>(begin: _anim.value, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.reset();
    _animController.duration = const Duration(milliseconds: 250);
    _animController.forward();
  }

  void _resetAnimationState() {
    setState(() {
      _dragOffset = 0;
      _isAnimating = false;
      _hasCompletedFirstAnimation = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onVerticalDragStart(DragStartDetails _) {
    // Cancel any ongoing animation
    if (_isAnimating) {
      _animController.stop();
      _isAnimating = false;
      _hasCompletedFirstAnimation = false;
      _dragOffset = _anim.value;
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!_isAnimating) {
      // Apply resistance as the drag gets further from center
      final double resistance = 1.0 - min(0.6, _dragOffset.abs() / 150);
      setState(() => _dragOffset += details.delta.dy * resistance);
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isAnimating) return;

    final velocity = details.primaryVelocity ?? 0;
    double targetOffset;

    // Determine direction based on velocity and position
    if (velocity < -800 || (_dragOffset < -30 && velocity < 0)) {
      // Swipe up (add value)
      targetOffset = -70;
    } else if (velocity > 800 || (_dragOffset > 30 && velocity > 0)) {
      // Swipe down (subtract value)
      targetOffset = 70;
    } else {
      // Not enough movement or velocity, animate back to zero
      _animateBackToZero();
      return;
    }

    // Start the animation sequence
    _startAnimationSequence(targetOffset);
  }

  void _startAnimationSequence(double targetOffset) {
    _isAnimating = true;
    _hasCompletedFirstAnimation = false;

    // Configure the animation
    _anim = Tween<double>(begin: _dragOffset, end: targetOffset).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    // Start the animation
    _animController.duration = const Duration(milliseconds: 300);
    _animController.reset();
    _animController.forward();
  }

  void _animateBackToZero() {
    _isAnimating = true;

    // Configure spring-like animation to zero
    _anim = Tween<double>(
      begin: _dragOffset,
      end: 0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    // Use shorter duration for return to zero
    _animController.duration = const Duration(milliseconds: 220);
    _animController.reset();
    _animController.forward().then((_) {
      _resetAnimationState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'e₹ ${_totalLoaded.toStringAsFixed(0)}',
          style: GoogleFonts.roboto(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60, // << smaller height instead of loose padding
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // center arrow and text nicely
              children: [
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white54,
                  size: 36,
                ),
                const SizedBox(height: 4), // less gap between arrow and text
                Text(
                  'SWIPE UP TO ADD, DOWN TO REMOVE',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _denominations.length,
                itemBuilder: (context, i) {
                  final isCurrent = i == _currentPage;
                  final double offset =
                      isCurrent
                          ? (_isAnimating ? _anim.value : _dragOffset)
                          : 0.0;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: ERupeeNote(idx: i),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0).copyWith(bottom: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: _totalLoaded > 0 ? Colors.green : Colors.white,
                foregroundColor: Colors.black,
                elevation: 4,
              ),
              onPressed: () {
                ref.read(eruppeProvider.notifier).state = _totalLoaded;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentScreen()),
                );
              },
              child: const Text(
                'Load Digital Rupee',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
