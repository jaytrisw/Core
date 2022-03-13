import Foundation

public extension UIViewController {
    
    func presentBannerView(
        with configuration: CUIBannerView.Configuration,
        model: CUIBannerView.Model,
        background: CUIBannerView.BackgroundView) {
            CUIBannerView(
                configuration: configuration,
                background: background)
                .present(
                    on: self,
                    model: model)
        }
    
}
