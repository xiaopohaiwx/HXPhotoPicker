//
//  EditorController.swift
//  HXPHPicker
//
//  Created by Slience on 2021/1/9.
//

import UIKit
import AVKit

#if canImport(Kingfisher)
import Kingfisher
#endif

open class EditorController: UINavigationController {
    
    public weak var videoEditorDelegate: VideoEditorViewControllerDelegate? {
        didSet {
            let vc = viewControllers.first as? VideoEditorViewController
            vc?.delegate = videoEditorDelegate
        }
    }
    
    public weak var photoEditorDelegate: PhotoEditorViewControllerDelegate? {
        didSet {
            let vc = viewControllers.first as? PhotoEditorViewController
            vc?.delegate = photoEditorDelegate
        }
    }
    
    /// 当前编辑类型
    public var editorType: EditorType
    
    /// 根据UIImage初始化
    /// - Parameters:
    ///   - image: 对应的UIImage
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(image: UIImage,
                editResult: PhotoEditResult? = nil,
                config: PhotoEditorConfiguration) {
        editorType = .photo
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let photoEditorVC = PhotoEditorViewController.init(image: image, editResult: editResult, config: config)
        self.viewControllers = [photoEditorVC]
    }
    
    /// 根据Data初始化
    /// - Parameters:
    ///   - imageData: 对应图片的Data
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(imageData: Data,
                editResult: PhotoEditResult? = nil,
                config: PhotoEditorConfiguration) {
        editorType = .photo
        self.config = config
        super.init(nibName: nil, bundle: nil)
        
        let image: UIImage
        #if canImport(Kingfisher)
        image = DefaultImageProcessor.default.process(item: .data(imageData), options: .init([]))!
        #else
        image = UIImage.init(data: imageData)!
        #endif
        let photoEditorVC = PhotoEditorViewController.init(image: image, editResult: editResult, config: config)
        self.viewControllers = [photoEditorVC]
    }
    
    #if canImport(Kingfisher)
    /// 编辑网络图片
    public init(networkImageURL: URL,
                editResult: PhotoEditResult? = nil,
                config: PhotoEditorConfiguration) {
        editorType = .photo
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let photoEditorVC = PhotoEditorViewController.init(networkImageURL: networkImageURL, editResult: editResult, config: config)
        self.viewControllers = [photoEditorVC]
    }
    #endif
    
    /// 编辑 Video
    /// - Parameters:
    ///   - videoURL: 本地视频地址
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public convenience init(videoURL: URL,
                            editResult: VideoEditResult? = nil,
                            config: VideoEditorConfiguration) {
        self.init(avAsset: AVAsset.init(url: videoURL), editResult: editResult, config: config)
    }
    
    /// 编辑 AVAsset
    /// - Parameters:
    ///   - avAsset: 视频对应的AVAsset对象
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(avAsset: AVAsset,
                editResult: VideoEditResult? = nil,
                config: VideoEditorConfiguration) {
        editorType = .video
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let videoEditorVC = VideoEditorViewController.init(avAsset: avAsset, editResult: editResult, config: config)
        self.viewControllers = [videoEditorVC]
    }
    
    /// 编辑网络视频
    /// - Parameters:
    ///   - networkVideoURL: 对应的网络视频地址
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(networkVideoURL: URL,
                editResult: VideoEditResult? = nil,
                config: VideoEditorConfiguration) {
        editorType = .video
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let videoEditorVC = VideoEditorViewController.init(networkVideoURL: networkVideoURL, editResult: editResult, config: config)
        self.viewControllers = [videoEditorVC]
    }
    
    #if HXPICKER_ENABLE_PICKER
    /// 根据PhotoAsset初始化
    /// - Parameters:
    ///   - photoAsset: 视频对应的PhotoAsset对象
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(photoAsset: PhotoAsset,
                editResult: VideoEditResult? = nil,
                config: VideoEditorConfiguration) {
        editorType = .video
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let videoEditorVC = VideoEditorViewController.init(photoAsset: photoAsset, editResult: editResult, config: config)
        self.viewControllers = [videoEditorVC]
    }
    
    /// 根据PhotoAsset初始化
    /// - Parameters:
    ///   - photoAsset: 照片对应的PhotoAsset对象
    ///   - editResult: 上一次编辑的结果，传入可在基础上进行编辑
    ///   - config: 编辑配置
    public init(photoAsset: PhotoAsset,
                editResult: PhotoEditResult? = nil,
                config: PhotoEditorConfiguration) {
        editorType = .photo
        self.config = config
        super.init(nibName: nil, bundle: nil)
        let photoEditorVC = PhotoEditorViewController.init(photoAsset: photoAsset, editResult: editResult, config: config)
        self.viewControllers = [photoEditorVC]
    }
    #endif
    
    /// 编辑器配置
    var config: EditorConfiguration
    
    open override var shouldAutorotate: Bool {
        config.shouldAutorotate
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        config.supportedInterfaceOrientations
    }
    open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        children.first
    } 
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
