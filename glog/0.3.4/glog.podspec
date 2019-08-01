Pod::Spec.new do |spec|
  spec.name = 'glog'
  spec.version = '0.3.4'
  spec.license = { :type => 'Google', :file => 'COPYING' }
  spec.homepage = 'https://github.com/google/glog'
  spec.summary = 'Google logging module'
  spec.authors = 'Google'

  spec.prepare_command = <<-CMD
set -e

PLATFORM_NAME="${PLATFORM_NAME:-iphoneos}"
CURRENT_ARCH="${CURRENT_ARCH:-armv7}"

export CC="$(xcrun -find -sdk $PLATFORM_NAME cc) -arch $CURRENT_ARCH -isysroot $(xcrun -sdk $PLATFORM_NAME --show-sdk-path)"
export CXX="$CC"

# Remove automake symlink if it exists
if [ -h "test-driver" ]; then
    rm test-driver
fi

./configure --host arm-apple-darwin

# Fix build for tvOS
cat << EOF >> src/config.h

/* Add in so we have Apple Target Conditionals */
#ifdef __APPLE__
#include <TargetConditionals.h>
#include <Availability.h>
#endif

/* Special configuration for AppleTVOS */
#if TARGET_OS_TV
#undef HAVE_SYSCALL_H
#undef HAVE_SYS_SYSCALL_H
#undef OS_MACOSX
#endif

/* Special configuration for ucontext */
#undef HAVE_UCONTEXT_H
#undef PC_FROM_UCONTEXT
#if defined(__x86_64__)
#define PC_FROM_UCONTEXT uc_mcontext->__ss.__rip
#elif defined(__i386__)
#define PC_FROM_UCONTEXT uc_mcontext->__ss.__eip
#endif
EOF

  CMD
  spec.source = { :git => 'https://github.com/google/glog.git',
                  :tag => "v#{spec.version}" }
  spec.module_name = 'glog'
  spec.header_dir = 'glog'
  spec.source_files = 'src/glog/*.h',
                      'src/demangle.cc',
                      'src/logging.cc',
                      'src/raw_logging.cc',
                      'src/signalhandler.cc',
                      'src/symbolize.cc',
                      'src/utilities.cc',
                      'src/vlog_is_on.cc'
  # workaround for https://github.com/facebook/react-native/issues/14326
  spec.preserve_paths = 'src/*.h',
                        'src/base/*.h'
  spec.exclude_files       = "src/windows/**/*"
  spec.libraries           = "stdc++"
  spec.pod_target_xcconfig = { "USE_HEADERMAP" => "NO",
                               "HEADER_SEARCH_PATHS" => "$(PODS_TARGET_SRCROOT)/src" }

  # Pinning to the same version as React.podspec.
  spec.platforms = { :ios => "8.0" }

end
