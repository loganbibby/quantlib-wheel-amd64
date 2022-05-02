#!/usr/bin/env bash

ROOT_DIR=/root_dir
QUANTLIB_INSTALL_DIR=quantlib
QUANTLIB_FILE=quantlib.tar.gz
QUANTLIB_SRC_DIR=quantlib-src
QUANTLIB_SWIG_FILE=quantlib-swig.tar.gz
QUANTLIB_SWIG_SRC_DIR=quantlib-swig-src

cd $ROOT_DIR

if [ ! -d $QUANTLIB_INSTALL_DIR ]; then
  echo "QuantLib installation not found... Installing..."

  echo "Downloading QuantLib v$QUANTLIB_VERSION"

  curl --silent -L -o $QUANTLIB_FILE https://github.com/lballabio/QuantLib/releases/download/QuantLib-v$QUANTLIB_VERSION/QuantLib-$QUANTLIB_VERSION.tar.gz

  if [ ! -f $QUANTLIB_FILE ]; then
    echo "Could not find QuantLib file: $QUANTLIB_FILE - Something may have went wrong with the download"
    exit 1
  fi

  tar zxf $QUANTLIB_FILE

  mv QuantLib-$QUANTLIB_VERSION $QUANTLIB_SRC_DIR

  if [ ! -d $QUANTLIB_SRC_DIR ]; then
    echo "Could not find QuantLib src directory: $QUANTLIB_SRC_DIR"
    exit 1
  fi

  echo "Installing QuantLib to $QUANTLIB_INSTALL_DIR"

  cd $QUANTLIB_SRC_DIR
  ./configure --disable-dependency-tracking --prefix=$QUANTLIB_INSTALL_DIR
  make
  make install
  ldconfig

  echo "Finished installed QuantLib"

else

  echo "Found QuantLib installation"

fi

export PATH=$PATH:$ROOT_DIR/$QUANTLIB_INSTALL_DIR/bin:$ROOT_DIR/$QUANTLIB_INSTALL_DIR/include

echo $PATH

if [ ! -d $QUANTLIB_SWIG_SRC_DIR ]; then
  echo "QuantLib SWIG source directory not found..."

  echo "Downloading QuantLib SWIG v$QUANTLIB_VERSION"

  curl --silent -L -o $QUANTLIB_SWIG_FILE https://github.com/lballabio/QuantLib-SWIG/releases/download/QuantLib-SWIG-v$QUANTLIB_VERSION/QuantLib-SWIG-$QUANTLIB_VERSION.tar.gz

  if [ ! -f $QUANTLIB_SWIG_FILE ]; then
    echo "Could not find QuantLib-SWIG file: $QUANTLIB_SWIG_FILE -- Something may have went wrong with the download"
    exit 1
  fi

  tar zxf $QUANTLIB_SWIG_FILE

  mv QuantLib-SWIG-$QUANTLIB_VERSION $QUANTLIB_SWIG_SRC_DIR
fi

if [ ! -d $QUANTLIB_SWIG_SRC_DIR ]; then
  echo "Could not find QuantLib-SWIG directory: $QUANTLIB_SWIG_SRC_DIR"
  exit 1
fi

echo "Installing QuantLib SWIG"

cd $QUANTLIB_SWIG_SRC_DIR
./configure
make -C Python
make -C Python install

#
# Generate Wheel

echo "Generating wheel"

cd Python
python setup.py bdist_wheel

if [ ! -d dist ]; then
  echo "Could not find Python wheel files"
  exit 1
fi

#
# Move wheel

mv dist/* $DROPDIR

echo "Wheel has been moved to $DROPDIR"

#
# The End

exit 0
