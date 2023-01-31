
import UIKit

class ViewController: UIViewController {
        
    // MARK: Section Definitions
    enum Section: Hashable {
        case promoted
        case standard(String)
        case categories
    }
    
    // MARK: SupplementaryViewKindsEnum
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }

    @IBOutlet var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Collection View Setup
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(PromotedAppCollectionViewCell.self, forCellWithReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier)
        collectionView.register(StandardAppCollectionViewCell.self, forCellWithReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)
        
        configureDataSource()
    }
    
    
    // MARK: Create layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            let section = self.sections[sectionIndex]
            
    
            // Header Item
            let headerItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .estimated(44)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerItemSize,
                elementKind: SupplementaryViewKind.header,
                alignment: .top
            )
            
            //Line Item
            let lineItemHeight = layoutEnviroment.traitCollection.displayScale
            let lineItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .absolute(1/lineItemHeight)
            )
            let topLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: lineItemSize,
                elementKind: SupplementaryViewKind.topLine,
                alignment: .top
            )
            let bottomLineItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: lineItemSize,
                elementKind: SupplementaryViewKind.bottomLine,
                alignment: .bottom
            )
            
            // Boundary Items Content Insets
            let supplementaryItemContentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 4,
                bottom: 0,
                trailing: 4
            )
            headerItem.contentInsets = supplementaryItemContentInsets
            topLineItem.contentInsets = supplementaryItemContentInsets
            bottomLineItem.contentInsets = supplementaryItemContentInsets

            
            
            
            switch section {
                
            case .promoted:
                // MARK: Promoted Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 4,
                    bottom: 0,
                    trailing: 4
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(300)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 0,
                    bottom: 20,
                    trailing: 0
                )
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [topLineItem, bottomLineItem]
                
                return section
                
            case .standard:
                // MARK: Standard Section Layout
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 20,
                    bottom: 0,
                    trailing: 4
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.92),
                    heightDimension: .estimated(250)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 8,
                    leading: 0,
                    bottom: 20,
                    trailing: 0
                )
                section.orthogonalScrollingBehavior = .groupPaging
                section.boundarySupplementaryItems = [headerItem, bottomLineItem]
                
                return section
                
            case .categories:
                // MARK: Categories Section Layout
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.1)
                )
                
                
                // MARK: Insets
                let availableLayoutWidth = layoutEnviroment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.92
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2.0
                let nonCategorySectionItemInset = CGFloat(4)
                let itemLeadingAndTrailingInset = halfOfRemainingWidth + nonCategorySectionItemInset
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: itemLeadingAndTrailingInset,
                    bottom: 0,
                    trailing: itemLeadingAndTrailingInset
                )
                
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(44)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem]
                                
                return section
            }
        }
        
        return layout
    }
    

    func configureDataSource() {
        
        // MARK: Data Source Initialisation
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            
            switch section {
            case .promoted:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PromotedAppCollectionViewCell.reuseIdentifier,
                    for: indexPath) as! PromotedAppCollectionViewCell
                cell.configureCell(item.app!)
                
                return cell
            case .standard:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: StandardAppCollectionViewCell.reuseIdentifier,
                    for: indexPath) as! StandardAppCollectionViewCell
                
                let isThirdItem = (indexPath.row + 1).isMultiple(of: 3)
                cell.configureCell(item.app!, hideBottomLine: isThirdItem)
                
                return cell
            case .categories:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
                    for: indexPath) as! CategoryCollectionViewCell
                let isLastItem = collectionView.numberOfItems(inSection: indexPath.section) == indexPath.row + 1
                cell.configureCell(item.category!, hideBottomLine: isLastItem)
                
                return cell
            }
        })
        dataSource.supplementaryViewProvider = {
            collectionView, kind, indexPath -> UICollectionReusableView? in
            
            switch kind {
            case SupplementaryViewKind.header:
                
                // Titles
                let section = self.sections[indexPath.section]
                let sectionName: String
                
                switch section {
                case .promoted:
                    return nil
                case .standard(let name):
                    sectionName = name
                case .categories:
                    sectionName = "Top Categories"
                }
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.setTitle(sectionName)
                return headerView
            case SupplementaryViewKind.bottomLine, SupplementaryViewKind.topLine:
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                return lineView
            default:
                return nil
            }
        }
        
        // MARK: Snapshot definition
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.promoted])
        snapshot.appendItems(Item.promotedApps, toSection: .promoted)
        
        let popularSection = Section.standard("Popular this Week")
        let essentialSection = Section.standard("Essential Picks")
        let categoriesSection = Section.categories
        
        snapshot.appendSections([popularSection, essentialSection, categoriesSection])
        snapshot.appendItems(Item.popularApps, toSection: popularSection)
        snapshot.appendItems(Item.essentialApps, toSection: essentialSection)
        snapshot.appendItems(Item.categories, toSection: categoriesSection)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}

