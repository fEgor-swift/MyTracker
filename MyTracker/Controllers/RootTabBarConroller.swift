import UIKit

final class RootTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        configureCustomTabBarAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        insertTopBorder()
    }

    private func configureTabs() {
        let habitsScreen = HabitsViewController()
        habitsScreen.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerTab_Icon"),
            tag: 0
        )
        
        let statsScreen = StatisticsViewController()
        statsScreen.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "StatisticsTab_Icon"),
            tag: 1
        )

        viewControllers = [
            UINavigationController(rootViewController: habitsScreen),
            UINavigationController(rootViewController: statsScreen)
        ]
    }

    private func insertTopBorder() {
        let line = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1))
        line.backgroundColor = UIColor(named: "ypLightGray")
        line.tag = 999
        if tabBar.viewWithTag(999) == nil {
            tabBar.addSubview(line)
        }
    }
    private func configureCustomTabBarAppearance() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "ypWhite")

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
}
