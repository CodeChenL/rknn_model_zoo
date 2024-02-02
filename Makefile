all:
	cd ./examples/yolov8/model && \
	bash ./download_model.sh && \
	cd ../python && \
	python3 convert.py ../model/yolov8n.onnx rk3588 i8 ../model/yolov8_rk3588.rknn && \
	python3 convert.py ../model/yolov8n.onnx rk3568 i8 ../model/yolov8_rk3568.rknn && \
	python3 convert.py ../model/yolov8n.onnx rk3568 i8 ../model/yolov8_rk3566.rknn

.PHONY: distclean
distclean: clean

clean: clean-deb
	find ./ -type f -name "*.onnx" -exec rm {} \;
	find ./ -type f -name "*.rknn" -exec rm {} \;

.PHONY: clean-deb
clean-deb:
	rm -rf debian/.debhelper debian/rknn-model-zoo debian/debhelper-build-stamp debian/files debian/*.debhelper.log debian/*.postrm.debhelper debian/*.substvars debian/*.debhelper.log

#
# Release
#
.PHONY: dch
dch: debian/changelog
	EDITOR=true gbp dch --commit --debian-branch=main --release --dch-opt=--upstream

.PHONY: deb
deb: debian
	debuild --no-lintian --lintian-hook "lintian --fail-on error,warning --suppress-tags bad-distribution-in-changes-file -- %p_%v_*.changes" --no-sign -b

.PHONY: release
release:
	gh workflow run .github/workflows/new_version.yml
