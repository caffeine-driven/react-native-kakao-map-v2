import * as React from 'react';

import {
  Button,
  type NativeSyntheticEvent,
  StyleSheet,
  Switch,
  Text,
  TextInput,
  View,
} from 'react-native';
import {
  type KakaoMapV2Props,
  KakaoMapV2View,
} from 'react-native-kakao-map-v2';
import { useState } from 'react';
import {
  type BalloonLabelSelectEvent,
  type CameraChangeEvent,
} from '../../src/event';
import type { CurrentLocationMarkerOption } from '../../src/labels';
import { lines } from './loadLines';

interface Form {
  latitude: string;
  longitude: string;
  zoomLevel: string;
  rotate: string;
  tilt: string;
}
let lodLabelId = 1;
let labelId = 1;
export default function App() {
  const [form, setForm] = useState<Form>({
    latitude: '33.56535720825195',
    longitude: '126.55416870117188',
    zoomLevel: '9',
    rotate: '0.0',
    tilt: '0.0',
  });
  const [mapProps, setMapProps] = useState<KakaoMapV2Props>({
    centerPosition: {
      latitude: parseFloat(form.latitude),
      longitude: parseFloat(form.longitude),
      zoomLevel: parseInt(form.zoomLevel),
    },
    lodLabels: [],
    balloonLabels: [],
    showCurrentLocationMarker: false,
    currentLocationMarkerOption: {
      latitude: 33.56535720825195,
      longitude: 126.55416870117188,
      markerImage: 'current_location_marker',
      offsetX: 0.5,
      offsetY: 0.7,
    },
  });

  const addLodLabels = () => {
    const latitude = 33.06535720825195 + Math.random();
    const longitude = 126.05416870117188 + Math.random();
    const newLabels = [
      ...(mapProps.lodLabels ?? []),
      {
        id: `balloon-label-${lodLabelId}`,
        latitude,
        longitude,
        styles: [
          {
            icon: 'station_marker_active',
            anchorPoint: { x: 0.5, y: 1.0 },
            // transitionType: 'NONE',
            // badges: [],
            zoomLevel: 0,
            textStyles: [{ fontSize: 14, fontColor: '#000000' }],
          },
        ],
        clickable: true,
        texts: [`balloon-label-${lodLabelId}`, `balloon-label-${lodLabelId}`],
      },
    ];
    lodLabelId++;
    setMapProps({
      ...mapProps,
      lodLabels: newLabels,
    });
  };

  const removeLodLabel = () => {
    const curLabels = mapProps.lodLabels ?? [];
    if (curLabels.length == 0) {
      return;
    }
    const removeIdx = Math.floor(Math.random() * curLabels.length);
    const nextLabels = curLabels.filter((_v, i) => i !== removeIdx);
    setMapProps({
      ...mapProps,
      lodLabels: nextLabels,
    });
  };

  const addBalloonMarker = () => {
    const latitude = 33.06535720825195 + Math.random();
    const longitude = 126.05416870117188 + Math.random();
    const newLabels = [
      ...(mapProps.balloonLabels ?? []),
      {
        id: `balloon-label-${labelId}`,
        latitude,
        longitude,
        title: `balloon-label-${labelId}`,
        activeIcon: 'station_marker_active',
        inactiveIcon: 'station_marker_inactive',
      },
    ];
    labelId++;
    setMapProps({
      ...mapProps,
      balloonLabels: newLabels,
    });
  };

  const removeBalloonLabel = () => {
    const curLabels = mapProps.balloonLabels ?? [];
    if (curLabels.length == 0) {
      return;
    }
    const removeIdx = Math.floor(Math.random() * curLabels.length);
    console.log(removeIdx);
    const nextLabels = curLabels.filter((_v, i) => i !== removeIdx);
    setMapProps({
      ...mapProps,
      balloonLabels: nextLabels,
    });
  };
  const updateCurrentBalloonLabel = (
    e: NativeSyntheticEvent<BalloonLabelSelectEvent>
  ) => {
    console.log(e.nativeEvent);
    setMapProps({
      ...mapProps,
      selectedBalloonLabel: e.nativeEvent.labelId,
    });
  };

  const updateForm =
    (name: string) =>
    <T,>(val: T) => {
      setForm({
        ...form,
        [name]: val,
      });
    };

  const updateProps = () => {
    const newProps = {
      ...mapProps,
      centerPosition: {
        ...mapProps.centerPosition,
        latitude: parseFloat(form.latitude),
        longitude: parseFloat(form.longitude),
        zoomLevel: parseInt(form.zoomLevel),
      },
      rotate: form.rotate ? parseFloat(form.rotate) : undefined,
      tilt: form.tilt ? parseFloat(form.tilt) : undefined,
    };

    setMapProps(newProps);
  };

  const rotateTest = (direction: boolean) => () => {
    let angle = 0;

    const handler = setInterval(() => {
      let prevOption = mapProps.currentLocationMarkerOption;
      const currentLocationMarkerOption: CurrentLocationMarkerOption = {
        ...prevOption,
        angle,
        markerImage: prevOption?.markerImage!!,
        latitude: prevOption?.latitude!!,
        longitude: prevOption?.longitude!!,
      };
      setMapProps({ ...mapProps, currentLocationMarkerOption });
      angle += direction ? 90 : -90;
    }, 1000);
    setTimeout(() => {
      clearInterval(handler);
    }, 10800);
  };
  const rotateMap = (enable: boolean) => {
    let prevOption = mapProps.currentLocationMarkerOption;
    const currentLocationMarkerOption: CurrentLocationMarkerOption = {
      ...prevOption,
      markerImage: prevOption?.markerImage!!,
      latitude: prevOption?.latitude!!,
      longitude: prevOption?.longitude!!,
      rotateMap: enable,
    };
    setMapProps({ ...mapProps, currentLocationMarkerOption });
  };

  const updateFromView = (e: NativeSyntheticEvent<CameraChangeEvent>) => {
    const cameraPosition = e.nativeEvent.cameraPosition;
    console.log(cameraPosition);
    const newForm = {
      ...form,
      latitude: `${cameraPosition.centerPosition.latitude}`,
      longitude: `${cameraPosition.centerPosition.longitude}`,
      zoomLevel: `${cameraPosition.centerPosition.zoomLevel}`,
      rotate: `${cameraPosition.rotate}`,
      tilt: `${cameraPosition.tilt}`,
    };
    const newProps = {
      ...mapProps,
      ...cameraPosition,
    };
    setForm(newForm);
    setMapProps(newProps);
  };

  return (
    <View style={styles.container}>
      <KakaoMapV2View
        style={styles.box}
        {...mapProps}
        onCameraChange={updateFromView}
        onBalloonLabelSelect={updateCurrentBalloonLabel}
        onLodLabelSelect={(e) => {
          (mapProps.lodLabels ?? []).forEach((it) => {
            if (it.id == e.nativeEvent.labelId) {
              console.log(it, e.nativeEvent.layerId);
            }
          });
          console.log(e.nativeEvent);
        }}
      />
      <View style={styles.overlay}>
        <View style={styles.div}>
          <TextInput
            style={styles.texts}
            value={`${form?.latitude}`}
            onChangeText={updateForm('latitude')}
          />
          <TextInput
            style={styles.texts}
            value={`${form?.longitude}`}
            onChangeText={updateForm('longitude')}
          />
        </View>
        <View style={styles.div}>
          <TextInput
            style={styles.texts}
            value={`${form?.zoomLevel}`}
            onChangeText={updateForm('zoomLevel')}
          />
          <TextInput
            style={styles.texts}
            value={`${form.rotate}`}
            onChangeText={updateForm('rotate')}
          />
          <TextInput
            style={styles.texts}
            value={`${form.tilt}`}
            onChangeText={updateForm('tilt')}
          />
          <Button title="apply" onPress={updateProps} />
        </View>
        <View style={styles.div}>
          <Button title="add balloon marker" onPress={addBalloonMarker} />
          <Button title="remove balloon marker" onPress={removeBalloonLabel} />
        </View>
        <View style={styles.div}>
          <Button title="add lod marker" onPress={addLodLabels} />
          <Button title="remove lod marker" onPress={removeLodLabel} />
        </View>
        <View style={styles.div}>
          <Button title="rotation cw" onPress={rotateTest(true)} />
          <Button title="rotation acw" onPress={rotateTest(false)} />
        </View>
        <View style={styles.div}>
          <Text>current loc toggle</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={
              mapProps.showCurrentLocationMarker ? '#f5dd4b' : '#f4f3f4'
            }
            ios_backgroundColor="#3e3e3e"
            onValueChange={(val) =>
              setMapProps({ ...mapProps, showCurrentLocationMarker: val })
            }
            value={mapProps.showCurrentLocationMarker}
          />
          <Text>rotate map</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={
              mapProps.showCurrentLocationMarker ? '#f5dd4b' : '#f4f3f4'
            }
            ios_backgroundColor="#3e3e3e"
            onValueChange={rotateMap}
            value={mapProps.currentLocationMarkerOption?.rotateMap ?? false}
          />
        </View>
        <View style={styles.div}>
          <Text>draw lines</Text>
          <Switch
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={
              mapProps.showCurrentLocationMarker ? '#f5dd4b' : '#f4f3f4'
            }
            ios_backgroundColor="#3e3e3e"
            onValueChange={(val) =>
              setMapProps({ ...mapProps, routeLines: val ? lines : undefined })
            }
            value={mapProps.routeLines != null}
          />
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: '100%',
    height: '100%',
  },
  overlay: {
    width: '100%',
    height: '100%',
    position: 'absolute',
    flex: 1,
    alignItems: 'flex-start',
    justifyContent: 'flex-start',
    padding: 20,
  },
  div: {
    width: '100%',
    position: 'relative',
    flexWrap: 'wrap',
    alignItems: 'flex-start',
    justifyContent: 'space-around',
    flexDirection: 'row',
  },
  texts: {
    maxWidth: '50%',
  },
  btn: {
    marginLeft: 5,
  },
});
