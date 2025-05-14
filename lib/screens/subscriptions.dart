import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>
    with SingleTickerProviderStateMixin {
  String selectedPlan = 'Premium Membership';

  final plans = [
    {
      'title': 'Basic Membership',
      'price': 'Free',
      'features': [
        'Watch with ads.',
        'Lower Quality',
      ],
      'badge': null,
    },
    {
      'title': 'Premium Membership',
      'price': '₹79',
      'features': [
        'Watch without ads.',
        'High Quality',
      ],
      'badge': 'Best Deal',
    },
    {
      'title': 'Referrals',
      'price': '10 Referrals',
      'features': [
        'Watch without ads for 2 hours (10 referrals)',
      ],
      'badge': null,
    },
  ];

  void selectPlan(String plan) {
    setState(() {
      selectedPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101622),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          children: [
            const SizedBox(height: 10),
            const Text(
              "Unlimited. Entertainment. Fun.",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose a membership to access content with varying features. Instant streaming, no commitment.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Plan Cards
            ...plans.asMap().entries.map((entry) {
              final idx = entry.key;
              final plan = entry.value;
              return _buildPlanCard(plan, idx);
            }),

            const SizedBox(height: 18),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Need a Custom Plan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Continue With ${selectedPlan.split(' ')[0]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Compare Plans
            const Text(
              "Compare Plans",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 14),
            _buildComparisonTable(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int idx) {
    final bool isSelected = selectedPlan == plan['title'];
    final badge = plan['badge'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 18),
      transform: isSelected
          ? (Matrix4.identity()..scale(1.04))
          : Matrix4.identity(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF232B3E),
            const Color(0xFF181D2A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: isSelected
            ? Border.all(color: Colors.greenAccent.shade400, width: 2.5)
            : Border.all(color: Colors.transparent),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.11),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plan details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Plan",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        plan['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        plan['price'],
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (plan['features'] as List).length,
                        (idx) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.greenAccent.shade400, size: 18),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  plan['features'][idx],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection checkmark
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isSelected
                      ? Icon(Icons.radio_button_checked,
                          color: Colors.greenAccent.shade400, size: 30, key: const ValueKey('checked'))
                      : Icon(Icons.radio_button_off,
                          color: Colors.white30, size: 28, key: const ValueKey('unchecked')),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                ),
              ],
            ),
          ),
          // Badge
          if (badge != null)
            Positioned(
              right: 18,
              top: 16,
              child: AnimatedOpacity(
                opacity: isSelected ? 1 : 0.7,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.16),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          // Tap overlay animation
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                splashColor: Colors.greenAccent.withOpacity(0.13),
                highlightColor: Colors.greenAccent.withOpacity(0.07),
                onTap: () => selectPlan(plan['title']),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable() {
    // Features and which plan has them
    final features = [
      {
        'feature': 'Watch without ads',
        'plans': [false, true, true],
      },
      {
        'feature': 'High video quality',
        'plans': [false, true, false],
      },
      {
        'feature': 'Temporary ad-free viewing',
        'plans': [false, false, true],
      },
      {
        'feature': 'Referral-based access',
        'plans': [false, false, true],
      },
    ];

    final planTitles = [
      'Basic',
      'Premium',
      'Referrals',
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF181E2A).withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.2),
          1: FlexColumnWidth(1.2),
          2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.2),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.white12, width: 1),
        ),
        children: [
          // Header
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Features',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              ...planTitles.map(
                (t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    t,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          // Feature rows
          ...features.map((row) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    row['feature'] as String,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                  ),
                ),
                ...List.generate(3, (idx) {
                  bool has = (row['plans'] as List)[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: has
                          ? const Icon(Icons.check,
                              color: Colors.greenAccent, size: 20)
                          : const Icon(Icons.close,
                              color: Colors.redAccent, size: 18),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
