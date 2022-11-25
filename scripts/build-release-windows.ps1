$ErrorActionPreference="Stop"

$VERSION = cat .\VERSION
$CARGO_PROFILE_RELEASE_LTO = "fat"
$TARGET = "x86_64-pc-windows-msvc"
$env:PYO3_NO_PYTHON = 1 

mkdir -force release > $null

cargo build --release -p cozoserver -p cozo_c -p cozo_java -p cozo-node -F compact -F storage-rocksdb --target $TARGET
cp target/$TARGET/release/cozoserver.exe release/cozoserver-$VERSION-$TARGET.exe # standalone
cp target/$TARGET/release/cozo_c.lib release/libcozo_c-$VERSION-$TARGET.lib # c static
cp target/$TARGET/release/cozo_c.dll release/libcozo_c-$VERSION-$TARGET.dll # c dynamic
cp target/$TARGET/release/cozo_java.dll release/libcozo_java-$VERSION-$TARGET.dll # java
cp target/$TARGET/release/cozo_node.dll release/libcozo_node-$VERSION-$TARGET.dll # nodejs

cd cozo-lib-python
maturin build -F compact -F storage-rocksdb --release --strip --target $TARGET
cd ..

cp target/wheels/*.whl release/