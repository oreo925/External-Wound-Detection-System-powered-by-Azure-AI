import 'package:flutter/material.dart';
import '../../../../../utilis/constants/colors.dart';
import '../../../../../utilis/helpers/helper_function.dart';
import '../../../models/first_aid_model.dart';

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: WColors.white),
        backgroundColor: WColors.primary,
        title: Text(
          'First Aid',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: WColors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          FirstAidItem(
            title: 'Treating Minor Cuts and Scrapes',
            description:
                '1. Clean the wound with mild soap and water.\n2. Apply an antibiotic ointment.\n3. Cover the wound with a sterile bandage. \n4. Get a tetanus shot if needed.\n5. Watch for signs of infection. \n6. Seek medical help if the wound is deep or the bleeding does not stop after applying pressure.',
            aids: [
              AidItem(
                title: 'Sterile Bandage',
                imageUrl: 'assets/first_aid/sterile_bandage.png',
                details: 'Used to cover and protect minor wounds.',
              ),
              AidItem(
                title: 'Antibiotic Ointment',
                imageUrl: 'assets/first_aid/antibiotic_ointment.png',
                details: 'Helps prevent infection and promote healing.',
              ),
              // Add more aid items as needed
            ],
          ),
         
         
          FirstAidItem(
            title: 'Treatment for Avulsions',
            description:
                'Injuries typically heal from the bottom up and from the edges in. In an avulsion, all layers of skin are removed, so there is no way for the injury to heal from the bottom up. It can only heal from the edges inward, and as a result may take some time to heal.The treatment you need will depend on the severity of your injury. Smaller injuries can be treated at home, while more significant injuries will need medical care. The size and severity of your injury will determine what kind of treatment option your medical provider chooses.',
            aids: [
              AidItem(
                title: 'Stitches',
                imageUrl: 'assets/first_aid/stitches.png',
                details: 'to close the wound to help it heal..',
              ),
              
              // Add more aid items as needed
            ],
          ),

          FirstAidItem(
            title: 'Treatment for Laceration',
            description:
                'To treat the laceration before you see the doctor:Apply direct pressure to the wound. Use gauze, a clean cloth, plastic bags, or, as a last resort, a clean hand. \nIf your wound bleeds through the gauze or cloth, do not remove it. \nAdd more gauze.\n If possible, elevate the wound above the heart. This will make it harder for blood to flow to the wound. \nDo not tie a tourniquet around an affected limb. This may cause more damage.\n If bleeding stops, let some water run over the wound. Tap water is safe to use.\nIf muscle, tendon, bone, or organs are exposed, do not try to push them back into place.\nIf you are feeling faint, lie down or sit with your head between your knees.',
            aids: [
              AidItem(
                title: 'DermaBond',
                imageUrl: 'assets/first_aid/dermabond.png',
                details: 'Dermabond will fall off in 5-10 days',
              ),
              // Add more aid items as needed
            ],
          ),

           FirstAidItem(
            title: 'Treatment for Punctures',
            description:
                'Wash your hands with soap and water or antibacterial cleanser \n Stop the bleeding by applying direct pressure to the injured area with a clean cloth, paper towel or piece of gauze \nWash the wound with clean, cool water and mild soap\nApply an antibiotic ointment to reduce chance of infection\nPlace a sterile bandage on the wound',
            aids: [
              AidItem(
                title: 'Apply Ointment',
                imageUrl: 'assets/first_aid/ointment.png',
                details: 'Apply an antibiotic ointment to reduce chance of infection',
              ),
              // Add more aid items as needed
            ],
          ),

           FirstAidItem(
            title: 'Treatment for Abrasions',
            description:
                'Washing the wound gently with soap and water. \n Patting the wound dry after washing it. Use a clean washcloth to do this.\n Applying a topical antibiotic ointment to the abrasion to prevent infection. \n ',
            aids: [
              AidItem(
                title: 'Dress the Wound',
                imageUrl: 'assets/first_aid/dressing.png',
                details: 'Apply a sterile bandage to protect the wound and keep it clean.',
              ),
              // Add more aid items as needed
            ],
          ),
          // Add more first aid items as needed
        ],
      ),
    );
  }
}

class FirstAidItem extends StatelessWidget {
  const FirstAidItem(
      {super.key,
      required this.title,
      required this.description,
      required this.aids});
  final String title;
  final String description;
  final List<AidItem> aids;
  

  @override
  Widget build(BuildContext context) {
    final drak = THelperFunctions.isDarkMode(context);
    return Card(
      shadowColor: WColors.black,
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: aids.map((aid) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to a new screen to display aid details
                    // You can implement this navigation logic here
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        aid.imageUrl,
                        height: 40,
                        color: drak ? WColors.white : WColors.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        aid.title,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
