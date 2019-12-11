// Generated by Apple Swift version 5.0.1 (swiftlang-1001.0.82.4 clang-1001.0.46.5)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreBluetooth;
@import CoreGraphics;
@import Foundation;
@import MultipeerConnectivity;
@import ObjectiveC;
@import SpriteKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="MultiTouchKitSwift",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC18MultiTouchKitSwift16GazeTableManager")
@interface GazeTableManager : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class MCNearbyServiceBrowser;
@class MCPeerID;

@interface GazeTableManager (SWIFT_EXTENSION(MultiTouchKitSwift)) <MCNearbyServiceBrowserDelegate>
- (void)browser:(MCNearbyServiceBrowser * _Nonnull)browser foundPeer:(MCPeerID * _Nonnull)peerID withDiscoveryInfo:(NSDictionary<NSString *, NSString *> * _Nullable)info;
- (void)browser:(MCNearbyServiceBrowser * _Nonnull)browser lostPeer:(MCPeerID * _Nonnull)peerID;
@end

@class MCSession;
@class NSInputStream;
@class NSProgress;

@interface GazeTableManager (SWIFT_EXTENSION(MultiTouchKitSwift)) <MCSessionDelegate>
- (void)session:(MCSession * _Nonnull)session peer:(MCPeerID * _Nonnull)peerID didChangeState:(MCSessionState)state;
- (void)session:(MCSession * _Nonnull)session didReceiveData:(NSData * _Nonnull)data fromPeer:(MCPeerID * _Nonnull)peerID;
- (void)session:(MCSession * _Nonnull)session didReceiveStream:(NSInputStream * _Nonnull)stream withName:(NSString * _Nonnull)streamName fromPeer:(MCPeerID * _Nonnull)peerID;
- (void)session:(MCSession * _Nonnull)session didStartReceivingResourceWithName:(NSString * _Nonnull)resourceName fromPeer:(MCPeerID * _Nonnull)peerID withProgress:(NSProgress * _Nonnull)progress;
- (void)session:(MCSession * _Nonnull)session didFinishReceivingResourceWithName:(NSString * _Nonnull)resourceName fromPeer:(MCPeerID * _Nonnull)peerID atURL:(NSURL * _Nullable)localURL withError:(NSError * _Nullable)error;
- (void)session:(MCSession * _Nonnull)session didReceiveCertificate:(NSArray * _Nullable)certificate fromPeer:(MCPeerID * _Nonnull)peerID certificateHandler:(void (^ _Nonnull)(BOOL))certificateHandler;
@end


/// Protocol to implement of instance that wants to be the delegate for any Bluetooth peripheral.
SWIFT_PROTOCOL("_TtP18MultiTouchKitSwift25MTKBluetoothNotifications_")
@protocol MTKBluetoothNotifications
@property (nonatomic, readonly, copy) NSString * _Nonnull observerName;
@optional
- (void)discoveredWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID;
- (void)connectedToPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID;
- (void)disconnectedFromPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID;
- (void)surfaceSensorUpdateWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID value:(BOOL)value;
- (void)lightSensorUpdateWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID value:(BOOL)value;
- (void)rotationSensorUpdateWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID xValue:(double)xValue yValue:(double)yValue zValue:(double)zValue;
@end

@class NSCoder;

SWIFT_CLASS("_TtC18MultiTouchKitSwift18MTKPassiveTangible")
@interface MTKPassiveTangible : SKNode
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC18MultiTouchKitSwift17MTKActiveTangible")
@interface MTKActiveTangible : MTKPassiveTangible <MTKBluetoothNotifications>
/// Used to identify different observers in the MTKBluetoothManager.
@property (nonatomic, readonly, copy) NSString * _Nonnull observerName;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)surfaceSensorUpdateWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID value:(BOOL)value;
- (void)rotationSensorUpdateWithPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID xValue:(double)xValue yValue:(double)yValue zValue:(double)zValue;
- (void)connectedToPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID;
- (void)disconnectedFromPeripheralName:(NSString * _Nonnull)peripheralName peripheralID:(NSUUID * _Nonnull)peripheralID;
@end


/// Model class representing a passive tangible, which can read/write all its individual characteristics using a dictionary
SWIFT_CLASS("_TtC18MultiTouchKitSwift23MTKPassiveTangibleModel")
@interface MTKPassiveTangibleModel : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// Model class representing an active tangible, which can read/write all its individual characteristics using a dictionary
SWIFT_CLASS("_TtC18MultiTouchKitSwift22MTKActiveTangibleModel")
@interface MTKActiveTangibleModel : MTKPassiveTangibleModel
@end


/// Model class representing an app, which can read/write all its individual characteristics using a dictionary
SWIFT_CLASS("_TtC18MultiTouchKitSwift11MTKAppModel")
@interface MTKAppModel : NSObject
/// Initializes an empty app model
///
/// returns:
/// Empty app model
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class CBCentralManager;
@class CBPeripheral;
@class NSNumber;
@class CBService;
@class CBCharacteristic;

SWIFT_CLASS("_TtC18MultiTouchKitSwift19MTKBluetoothManager")
@interface MTKBluetoothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
- (void)centralManagerDidUpdateState:(CBCentralManager * _Nonnull)central;
- (void)centralManager:(CBCentralManager * _Nonnull)central didDiscoverPeripheral:(CBPeripheral * _Nonnull)peripheral advertisementData:(NSDictionary<NSString *, id> * _Nonnull)advertisementData RSSI:(NSNumber * _Nonnull)RSSI;
- (void)centralManager:(CBCentralManager * _Nonnull)central didConnectPeripheral:(CBPeripheral * _Nonnull)peripheral;
- (void)centralManager:(CBCentralManager * _Nonnull)central didDisconnectPeripheral:(CBPeripheral * _Nonnull)peripheral error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didDiscoverServices:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didDiscoverCharacteristicsForService:(CBService * _Nonnull)service error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic * _Nonnull)characteristic error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didWriteValueForCharacteristic:(CBCharacteristic * _Nonnull)characteristic error:(NSError * _Nullable)error;
- (void)peripheral:(CBPeripheral * _Nonnull)peripheral didUpdateValueForCharacteristic:(CBCharacteristic * _Nonnull)characteristic error:(NSError * _Nullable)error;
@end



SWIFT_CLASS("_TtC18MultiTouchKitSwift22MTKBluetoothPeripheral")
@interface MTKBluetoothPeripheral : NSObject
- (BOOL)isEqual:(id _Nullable)object SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

@class MTKTrace;

/// Protocol to implement of instance that wants to be the delegate for any node (e.g. MTKScene).
SWIFT_PROTOCOL("_TtP18MultiTouchKitSwift22MTKNodeTraceProcessing_")
@protocol MTKNodeTraceProcessing
@optional
- (NSSet<MTKTrace *> * _Nonnull)preProcessTraceSetWithTraceSet:(NSSet<MTKTrace *> * _Nonnull)traceSet node:(SKNode * _Nonnull)node timestamp:(NSTimeInterval)timestamp SWIFT_WARN_UNUSED_RESULT;
- (NSSet<MTKTrace *> * _Nonnull)postProcessTraceSetWithTraceSet:(NSSet<MTKTrace *> * _Nonnull)traceSet node:(SKNode * _Nonnull)node timestamp:(NSTimeInterval)timestamp SWIFT_WARN_UNUSED_RESULT;
@end


SWIFT_CLASS("_TtC18MultiTouchKitSwift9MTKButton")
@interface MTKButton : SKNode <MTKNodeTraceProcessing>
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (NSSet<MTKTrace *> * _Nonnull)preProcessTraceSetWithTraceSet:(NSSet<MTKTrace *> * _Nonnull)traceSet node:(SKNode * _Nonnull)node timestamp:(NSTimeInterval)timestamp SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_PROTOCOL("_TtP18MultiTouchKitSwift17MTKButtonDelegate_")
@protocol MTKButtonDelegate
@optional
- (void)buttonPressedWithTrace:(MTKTrace * _Nonnull)trace button:(MTKButton * _Nonnull)button;
@end


/// The config controller is responsible for loading all configurations.
/// In general the file is read on startup of the application and not changed until it requests a change.
/// Any changes in the file while the application runs have no effect to the application if not reloading the config explicitly.
/// Applications should in general not change the config. The changes should be done with the TCC to ensure the file structure.
/// To avoid any read and write issues the controller uses the Singleton pattern.
SWIFT_CLASS("_TtC18MultiTouchKitSwift19MTKConfigController")
@interface MTKConfigController : NSObject
/// Initializes a new config controller
///
/// returns:
/// An initialized config controller
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


/// The config profile holds all settings general for use at one workstation.
/// It is also the parent of all other settings. What means any find settings can be found in components of this class.
SWIFT_CLASS("_TtC18MultiTouchKitSwift13MTKConfigFile")
@interface MTKConfigFile : NSObject
/// Initializes an empty model
///
/// returns:
/// Empty profile, only filled with basic standard values
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC18MultiTouchKitSwift14MTKInputSource")
@interface MTKInputSource : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/// Model class representing an input source, which can read/write all its individual characteristics using a dictionary
SWIFT_CLASS("_TtC18MultiTouchKitSwift19MTKInputSourceModel")
@interface MTKInputSourceModel : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC18MultiTouchKitSwift19MTKMouseInputSource")
@interface MTKMouseInputSource : MTKInputSource
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end





SWIFT_CLASS("_TtC18MultiTouchKitSwift20MTKProgressIndicator")
@interface MTKProgressIndicator : SKNode
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC18MultiTouchKitSwift8MTKScene")
@interface MTKScene : SKScene <MTKNodeTraceProcessing>
- (nonnull instancetype)init;
- (nonnull instancetype)initWithSize:(CGSize)size OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)update:(NSTimeInterval)currentTime;
@end


/// Describes one touch. It is the generalisation class, all different type of touches reaching our framework are transferred to this class.
SWIFT_CLASS("_TtC18MultiTouchKitSwift8MTKTrace")
@interface MTKTrace : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly) NSUInteger hash;
@end

@class NSEvent;

/// Class is used to transfer mouse events of the view to MTKInputSource of type mouse.
SWIFT_CLASS("_TtC18MultiTouchKitSwift7MTKView")
@interface MTKView : SKView
- (nonnull instancetype)initWithFrame:(NSRect)frameRect OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)mouseDown:(NSEvent * _Nonnull)event;
- (void)mouseDragged:(NSEvent * _Nonnull)event;
- (void)mouseUp:(NSEvent * _Nonnull)event;
- (void)rightMouseDown:(NSEvent * _Nonnull)event;
@end


/// The view model holds all configs related to a shown window
SWIFT_CLASS("_TtC18MultiTouchKitSwift12MTKViewModel")
@interface MTKViewModel : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end



#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
